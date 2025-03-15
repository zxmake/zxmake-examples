package("llvm", function()
    set_kind("toolchain")
    set_homepage("https://llvm.org/")
    set_description("The LLVM Compiler Infrastructure")

    on_fetch(function(package, opt)
        import("lib.detect.find_tool")
        import("core.project.target")

        if opt.system then
            local llvm_config = "llvm-config"

            local version = try {
                function()
                    return os.iorunv(llvm_config, {"--version"})
                end
            }
            if version then
                version = version:trim()
            end
            if version then
                return {version = version}
            end
        end
    end)

    on_test(function(package)
        if package:is_toolchain() and not package:is_cross() then
            os.vrun("llvm-config --version")
            if package:config("clang") then
                os.vrun("clang --version")
            end
        end
    end)
end)
