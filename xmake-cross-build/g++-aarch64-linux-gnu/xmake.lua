add_rules("mode.debug", "mode.release")

set_languages("c++17")

package("protobuf-cpp", function()
    add_urls(
        "https://github.com/protocolbuffers/protobuf/releases/download/v$(version)",
        {
            version = function(version)

                if version:le("3.19.4") then
                    return version .. "/protobuf-cpp-" .. version .. ".zip"
                end
            end
        })


    add_versions("3.15.8",
                 "093e0dca5277b377c36a48a3633325dca3d92d68ac17d5700a1f7e1c3eca2793")

    add_configs("zlib", {
        description = "Enable zlib",
        default = false,
        type = "boolean"
    })

    add_deps("cmake")

    add_links("protobuf", "protoc", "utf8_range", "utf8_validity")

    if is_plat("linux") then
        add_syslinks("pthread")
    end

    on_load(function(package)
        package:addenv("PATH", "bin")
        if package:config("zlib") then
            package:add("deps", "zlib")
        end
        if package:version():ge("22.0") then
            package:add("deps", "abseil")
        end
    end)

    on_install(function(package)
        if package:version():le("3.19.4") then
            os.cd("cmake")
        end
        -- io.replace("CMakeLists.txt", "set(protobuf_DEBUG_POSTFIX \"d\"",
        --            "set(protobuf_DEBUG_POSTFIX \"\"", {plain = true})



        local configs = {
            "-Dprotobuf_BUILD_TESTS=OFF", "-Dprotobuf_BUILD_PROTOC_BINARIES=ON"
        }
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" ..
                         (package:is_debug() and "Debug" or "Release"))
        table.insert(configs, "-DBUILD_SHARED_LIBS=" ..
                         (package:config("shared") and "ON" or "OFF"))

        local packagedeps = {}
        if package:version():ge("22.0") then
            table.insert(packagedeps, "abseil")
            table.insert(configs, "-Dprotobuf_ABSL_PROVIDER=package")
        end

        if package:config("zlib") then
            table.insert(configs, "-Dprotobuf_WITH_ZLIB=ON")
        end

        print(os.curdir())
        print(configs)
        print(packagedeps)
        print(os.getenvs())
        -- raise("fck")
        import("package.tools.cmake").install(package, configs, {
            buildir = "build",
            packagedeps = packagedeps
        })
    end)

    on_test(function(package)
        if package:is_cross() then
            return
        end
        io.writefile("test.proto", [[
            syntax = "proto3";
            package test;
            message TestCase {
                string name = 4;
            }
            message Test {
                repeated TestCase case = 1;
            }
        ]])
        os.vrun("protoc test.proto --cpp_out=.")
    end)
end)

-- 编译出 host 版本的 protoc, 用于生成 *.pb.h 和 *.pb.cc
-- add_requires("protobuf-cpp~host 3.19.4", {host = true, alias = "protoc"})
-- 编译出 cross 版本的 protobuf 库, 用于构造交叉编译成品库
add_requires("protobuf-cpp 3.15.8")

add_cxxflags("-Wno-error=unused-parameter")

target("pb", function()
    set_kind("object")
    add_files("pb/*.proto", { proto_public = true})
    add_rules("protobuf.cpp")
    add_packages("protobuf-cpp", {public = true})
    add_packages("protoc", {links = {}}) -- 只是为了获取 host protoc, 不引入 linkflags
    set_policy('build.fence', true)
end)

target("g++-aarch64-linux-gnu", function()
    set_kind("binary")
    add_files("src/*.cc")
    add_deps("pb")
end)
