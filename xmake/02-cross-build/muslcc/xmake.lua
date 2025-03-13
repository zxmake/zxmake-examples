add_rules("plugin.compile_commands.autoupdate", {outputdir = "."})
add_rules("mode.debug", "mode.release")

add_cxxflags("-Wall", "-Wextra", "-Werror")

add_requires("muslcc")

-- 等价于 xmake f -p cross --arch=arm --toolchain=muslcc
set_plat("cross")
set_arch("arm")
set_toolchains("@muslcc")

add_requires("zlib", "libogg", {system = false})

-- 为了生成 compile_commands.json
add_sysincludedirs(
    "/root/.xmake/packages/m/muslcc/20210202/f54cc74e8e224857a5b4d85f38f35406/arm-linux-musleabi/include")

target("test", function()
    set_kind("binary")
    add_files("src/*.c")
    add_packages("zlib", "libogg")
end)
