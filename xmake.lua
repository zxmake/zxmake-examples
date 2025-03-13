includes("xmake-cross-build/clang-sysroot-target/toolchain.lua")

option("project_name", function()
    set_description("xmake project name")
end)

-- bazel projects
if get_config("project_name") == "bazel-cross-build/custom-toolchain" then
    includes("bazel-cross-build/custom-toolchain/xmake.lua")
end
if get_config("project_name") == "bazel-cuda-target" or
    get_config("project_name") == "all" then
    includes("bazel-cuda-target/xmake.lua")
end

-- cmake projects
includes("cmake/**xmake.lua")

-- xmake projects
if get_config("project_name") == "xmake-cross-build/g++-aarch64-linux-gnu" then
    includes("xmake-cross-build/g++-aarch64-linux-gnu/xmake.lua")
end
if get_config("project_name") == "xmake-cross-build/zig" then
    includes("xmake-cross-build/zig/xmake.lua")
end
if get_config("project_name") == "xmake-cross-build/clang-sysroot-target" then
    includes("xmake-cross-build/clang-sysroot-target/xmake.lua")
end
if get_config("project_name") == "xmake-cross-build/llvm-11" then
    includes("xmake-cross-build/llvm-11/xmake.lua")
end

add_rules("plugin.compile_commands.autoupdate", {outputdir = "."})
add_rules("mode.debug", "mode.release")

add_cxxflags("-Wall", "-Wextra", "-Werror")
