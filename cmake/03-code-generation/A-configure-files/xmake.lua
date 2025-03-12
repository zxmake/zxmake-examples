target("cmake.03-code-generation.A-configure-files", function()
    set_kind("binary")
    -- 默认会识别到 .in 后缀并去掉, 也可以通过 filename 指定
    add_configfiles("ver.h.in", {
        filename = "ver.h",
        variables = {cf_example_VERSION = "1.0.0"}
    })
    add_configfiles("path.h.in", {
        filename = "path.h",
        pattern = "@(.-)@",
        variables = {CMAKE_SOURCE_DIR = "cmake-source-dir"}
    })
    add_files("main.cc")
    add_includedirs("$(buildir)")
end)
