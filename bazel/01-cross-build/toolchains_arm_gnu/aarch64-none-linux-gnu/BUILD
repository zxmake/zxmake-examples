load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")

platform(
    name = "aarch64_none_linux_gnu",
    constraint_values = [
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
)

cc_library(
    name = "arm_library",
    srcs = ["library.cc"],
    hdrs = ["library.h"],
    copts = [
        "-mcpu=cortex-a53",
    ],
    includes = ["includes"],
    target_compatible_with = [
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
)

cc_binary(
    name = "arm_elf",
    srcs = ["main.cc"],
    copts = [
        "-mcpu=cortex-a53",
    ],
    linkopts = [
        "-nostartfiles",
        "-Wl,--entry,main",
    ],
    deps = [":arm_library"],
)
