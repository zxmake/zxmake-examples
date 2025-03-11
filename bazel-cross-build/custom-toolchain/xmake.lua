add_includedirs(".")

target("bazel-cross-build.custom-toolchain.hello-time", function()
    set_kind("object")
    add_files("lib/hello-time.cc")
end)

target("bazel-cross-build.custom-toolchain.hello-greet", function()
    set_kind("object")
    add_files("main/hello-greet.cc")
end)

target("bazel-cross-build.custom-toolchain.hello-world", function()
    set_kind("binary")
    add_files("main/hello-world.cc")
    add_deps("bazel-cross-build.custom-toolchain.hello-time",
             "bazel-cross-build.custom-toolchain.hello-greet")
end)
