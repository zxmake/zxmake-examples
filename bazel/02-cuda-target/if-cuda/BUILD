load("@rules_cuda//cuda:defs.bzl", "cuda_library", "requires_cuda")

package(default_visibility = ["//visibility:public"])

cuda_library(
    name = "kernel",
    srcs = ["kernel.cu"],
    hdrs = ["kernel.h"],
    target_compatible_with = requires_cuda(),
)

cc_binary(
    name = "main",
    srcs = ["main.cc"],
    defines = [] + select({
        "@rules_cuda//cuda:is_enabled": ["CUDA_ENABLED"],
        "//conditions:default": ["CUDA_DISABLED"],
    }),
    deps = [] + select({
        "@rules_cuda//cuda:is_enabled": [":kernel"],
        "//conditions:default": [],
    }),
)
