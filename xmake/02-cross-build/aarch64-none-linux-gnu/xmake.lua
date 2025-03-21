add_rules("plugin.compile_commands.autoupdate", {outputdir = "."})
add_rules("mode.debug", "mode.release")

add_cxxflags("-Wall", "-Wextra", "-Werror")
set_languages("c++17")

-- 编译出 host 版本的 protoc, 用于生成 *.pb.h 和 *.pb.cc
add_requires("protobuf-cpp~host 3.19.4", {host = true, alias = "protoc"})
-- 编译出 cross 版本的 protobuf 库, 用于构造交叉编译成品库
add_requires("protobuf-cpp 3.19.4")

target("proto", function()
    set_kind("object")
    add_files("pb/*.proto", {proto_public = true})
    add_rules("protobuf.cpp")
    add_packages("protobuf-cpp", {public = true})
    add_packages("protoc", {links = {}, linkdirs = {}}) -- 只是为了获取 host protoc, 不引入 linkflags
    set_policy('build.fence', true)
end)

target("cc_main", function()
    set_kind("binary")
    add_files("src/*.cc")
    add_deps("proto")
end)

target("cuda_main", function()
    set_kind("binary")
    add_files("cuda/*.cu")
    add_files("cuda/main.cc")

    -- cuda 交叉编译需要配置的 toolset
    set_toolset("cu", "/usr/local/cuda/bin/nvcc")
    set_toolset("culd", "/usr/local/cuda/bin/nvcc")
    set_toolset("cu-ccbin", "/usr/bin/aarch64-linux-gnu-gcc")
    add_sysincludedirs("/usr/local/cuda-11.8/targets/x86_64-linux/include")
    -- cuda devlink 也需要搜索头文件
    add_culdflags("-isystem /usr/local/cuda-11.8/targets/x86_64-linux/include")
    -- cuda 交叉编译的 library path
    add_linkdirs("/usr/local/cuda-11.8/targets/aarch64-linux/lib")
end)
