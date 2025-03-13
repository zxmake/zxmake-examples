add_requires("llvm 14.0.0", {alias = "llvm-10"})

-- 3.12.3 版本会一直报错安装不了
add_requireconfs("**.python", {override = true, version = "3.11.8"})

target("xmake-cross-build.llvm-11.main", function()
    set_kind("binary")
    add_files("src/main.cc")
    set_toolchains("llvm@llvm-10")
end)
