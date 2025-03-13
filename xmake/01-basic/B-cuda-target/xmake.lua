add_rules("plugin.compile_commands.autoupdate", {outputdir = "."})
add_rules("mode.debug", "mode.release")

add_cxxflags("-Wall", "-Wextra", "-Werror")

target("xmake.01-basic.B-cuda-target.main", function()
    set_kind("binary")
    add_files("main.cc")
    add_files("kernel.cu")
end)
