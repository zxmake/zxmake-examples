add_rules("mode.debug", "mode.release")

set_languages("c++17")

-- 使用本地的 protoc
add_requires("protobuf-cpp 3.19.4")

target("xmake-cross-build.clang-sysroot-target.pb", function()
    set_kind("object")
    add_files("pb/*.proto", {proto_public = true})
    add_rules("protobuf.cpp")
    add_packages("protobuf-cpp", {public = true})
    set_policy('build.fence', true)
end)

target("xmake-cross-build.clang-sysroot-target.main", function()
    set_kind("binary")
    add_files("src/*.cc")
    add_deps("xmake-cross-build.clang-sysroot-target.pb")
end)
