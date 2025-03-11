# README

```
# 编译全部 target
cd bazel-cross-build/toolchains_arm_gnu
bazel build --platforms=//examples/arm-linux:arm_linux_gnueabihf //examples/arm-linux:arm_elf
bazel build --platforms=//examples/arm-none:arm_none_eabi //examples/arm-none:arm_elf
bazel build --platforms=//examples/custom/platform:cortex_m3 //examples/custom:binary
```
