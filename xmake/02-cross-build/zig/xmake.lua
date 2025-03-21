add_rules("plugin.compile_commands.autoupdate", {outputdir = "."})
add_rules("mode.debug", "mode.release")

add_cxxflags("-Wall", "-Wextra", "-Werror")

target("main", function()
    set_kind("binary")
    add_files("src/*.cc")
end)
