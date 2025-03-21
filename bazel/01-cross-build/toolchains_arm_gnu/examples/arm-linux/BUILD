load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")

platform(
    name = "arm_linux_gnueabihf",
    constraint_values = [
        "@platforms//cpu:arm",
        "@platforms//os:linux",
    ],
)

cc_library(
    name = "arm_library",
    srcs = ["library.cc"],
    hdrs = ["library.h"],
    copts = [
        "-mcpu=cortex-a5",
        "-mthumb",
    ],
    includes = ["includes"],
    target_compatible_with = [
        "@platforms//cpu:arm",
        "@platforms//os:linux",
    ],
)

# bazel build --platforms=//examples/arm-linux:arm_linux_gnueabihf //examples/arm-linux:arm_elf
cc_binary(
    name = "arm_elf",
    srcs = ["main.cc"],
    copts = [
        "-mcpu=cortex-a5",
        "-mthumb",
    ],
    deps = [":arm_library"],
)
