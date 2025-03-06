target("bazel-cross-build.hello-world", function()
    set_kind("binary")
    add_files("src/hello-world.cc")
end)
