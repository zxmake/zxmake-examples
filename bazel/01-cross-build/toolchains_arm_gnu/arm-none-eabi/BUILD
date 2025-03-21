load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")

platform(
    name = "arm_none_eabi",
    constraint_values = [
        "@platforms//cpu:arm",
        "@platforms//os:none",
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
        "@platforms//os:none",
    ],
)

cc_binary(
    name = "arm_elf",
    srcs = ["main.cc"],
    copts = [
        "-mcpu=cortex-a5",
        "-mthumb",
    ],
    features = ["generate_linkmap"],
    linkopts = [
        "-nostartfiles",
        "-Wl,--entry,main",
        "--specs=nano.specs",
    ],
    deps = [":arm_library"],
)
