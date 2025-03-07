add_includedirs(".")

target("bazel-cross-build.hello-time", function()
    set_kind("object")
    add_files("lib/hello-time.cc")
end)

target("bazel-cross-build.hello-greet", function()
    set_kind("object")
    add_files("main/hello-greet.cc")
end)

target("bazel-cross-build.hello-world", function()
    set_kind("binary")
    add_files("main/hello-world.cc")
    add_deps("bazel-cross-build.hello-time", "bazel-cross-build.hello-greet")
end)
