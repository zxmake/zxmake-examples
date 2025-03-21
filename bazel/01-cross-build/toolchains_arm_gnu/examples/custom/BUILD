load("@rules_cc//cc:defs.bzl", "cc_binary")

cc_binary(
    name = "binary",
    srcs = ["main.c"],
    linkopts = [
        "-Wl,-entry=main",
    ],
    target_compatible_with = [
        "@platforms//os:none",
    ],
)
