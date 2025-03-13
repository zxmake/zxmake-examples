toolchain("aarch64-clang", function()
    set_toolset("cc", "clang")
    set_toolset("cxx", "clang++")
    set_toolset("cpp", "clang -E")
    set_toolset("as", "clang")
    set_toolset("sh", "clang++")
    set_toolset("ld", "clang++")
    set_toolset("ar", "/usr/lib/llvm-14/bin/llvm-ar")
    set_toolset("strip", "/usr/lib/llvm-14/bin/llvm-strip")
    set_toolset("mm", "clang")
    set_toolset("mxx", "clang", "clang++")
    set_toolset("as", "clang")
    set_toolset("ranlib", "/usr/lib/llvm-14/bin/llvm-ranlib")

    -- 添加编译参数控制
    add_sysincludedirs("/usr/aarch64-linux-gnu/include",
                       "/usr/aarch64-linux-gnu/include/c++/11",
                       "/usr/aarch64-linux-gnu/include/c++/11/aarch64-linux-gnu")
    add_syslinks("stdc++", "m", "pthread")
    -- add_linkdirs("/opt/toolchain/orin/lib", "/opt/toolchain/orin/lib64")
    -- add_ldflags("-Wl,-rpath-link=/opt/toolchain/orin/lib",
    --             "-Wl,-rpath=/opt/toolchain/orin/lib")

    -- 设置交叉编译参数
    add_cxflags("-m64", "-fPIC", "--sysroot=/", "--target=aarch64-linux-gnu",
                "-march=armv8-a")
    add_ldflags("-m64", "--sysroot=/", "--target=aarch64-linux-gnu",
                "-march=armv8-a")
    add_shflags("-m64", "--sysroot=/", "-fPIC", "--target=aarch64-linux-gnu",
                "-march=armv8-a")

    on_load(function(toolchain)
        -- 设置运行时环境变量
        os.setenv("C_INCLUDE_PATH", "")
        os.setenv("CPLUS_INCLUDE_PATH", "")
    end)
end)
