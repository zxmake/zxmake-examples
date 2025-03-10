option("project_name", function()
    set_description("xmake project name")
end)

includes("bazel-cross-build/xmake.lua")

if get_config("project_name") == "bazel/bazel-cuda-target" then
    includes("bazel-cuda-target/xmake.lua")
end
if get_config("project_name") == "xmake/g++-aarch64-linux-gnu" then
    includes("xmake-cross-build/g++-aarch64-linux-gnu/xmake.lua")
end
if get_config("project_name") == "xmake/zig" then
    includes("xmake-cross-build/zig/xmake.lua")
end

add_rules("plugin.compile_commands.autoupdate", {outputdir = "."})
add_rules("mode.debug", "mode.release")

add_cxxflags("-Wall", "-Wextra", "-Werror")
