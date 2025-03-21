-- 自定义 package, 官方的 llvm 安装起来耗时巨长
includes("packages/llvm.lua")

add_rules("plugin.compile_commands.autoupdate", {outputdir = "."})
add_rules("mode.debug", "mode.release")

add_cxxflags("-Wall", "-Wextra", "-Werror")

-- packages/2502/l/llvm/14.0.0/source/llvm/tools/gold/gold-plugin.cpp:38:10: fatal error: plugin-api.h: No such file or directory
-- sudo apt install binutils-dev
-- @see https://blog.51cto.com/u_13721254/6163639
add_requires("llvm 14.0.0", {alias = "llvm-14", system = true})

-- 3.12.3 版本会一直报错安装不了
add_requireconfs("**.python", {override = true, version = "3.11.8"})

target("cc_main", function()
    set_kind("binary")
    add_files("src/main.cc")
    set_toolchains("llvm@llvm-14")
end)
