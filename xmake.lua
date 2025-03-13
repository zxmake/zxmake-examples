includes("xmake/02-cross-build/clang-sysroot-target/toolchain.lua")

option("project_name", function()
    set_description("xmake project name")
    set_default("common")
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
if get_config("project_name") == "common" then
    includes("cmake/**xmake.lua")
end

-- xmake projects, we need to enable them manually
if get_config("project_name") then
    includes(path.join(get_config("project_name"), "xmake.lua"))
end

add_rules("plugin.compile_commands.autoupdate", {outputdir = "."})
add_rules("mode.debug", "mode.release")

add_cxxflags("-Wall", "-Wextra", "-Werror")
