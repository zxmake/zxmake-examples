add_rules("mode.debug", "mode.release")

target("xmake.02-cross-build.zig.main", function()
    set_kind("binary")
    add_files("src/*.cc")
end)
