load(":cc_toolchain_config.bzl", "cc_toolchain_config")

package(default_visibility = ["//visibility:public"])

cc_toolchain_config(name = "linux_aarch64_toolchain_config")

filegroup(name = "empty")

cc_toolchain(
    name = "linux_aarch64_toolchain",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
    toolchain_config = ":linux_aarch64_toolchain_config",
    toolchain_identifier = "linux_aarch64-toolchain",
)

# https://bazel.build/reference/be/platforms-and-toolchains?hl=zh-cn#toolchain
# 此规则声明特定工具链的类型和约束条件，以便在工具链解析期间选择该工具链
toolchain(
    name = "cc_toolchain_for_linux_aarch64",
    # 执行平台必须满足的 constraint_value 列表, 以便为该平台上的目标 build 选择此工具链
    exec_compatible_with = [
        # 你的主机架构
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
    # 目标平台必须满足的 constraint_value 列表, 以便为该平台的目标 build 选择此工具链
    target_compatible_with = [
        # 目标架构
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
    # 此目标代表选择此工具链时可用的实际工具或工具套件
    toolchain = ":linux_aarch64_toolchain",
    # toolchain_type 目标的标签，表示此工具链所提供的角色
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)
