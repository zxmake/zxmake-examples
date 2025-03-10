# zxmake-examples

## Examples

* **bazel-cross-build**：Cross-compilation implemented with a custom toolchain.
* **bazel-cross-build2**：ARM cross-compilation using the packaged [toolchain](https://github.com/hexdae/toolchains_arm_gnu)
* **bazel-cross-build3**: 使用 [zig toolchain](https://github.com/uber/hermetic_cc_toolchain) 实现的 arm 交叉编译

## Docker

* ubuntu 22.04
* bazel v8.1.1
* xmake v3.0.5
* cmake 3.22.1
* clang 14.0.6
* gcc 9.5.0


```bash
# Build the Docker container
bash scripts/docker.sh build

# Run the Docker container
bash scripts/docker.sh run

# Remove the Docker container and image
# bash scripts/docker.sh clear --image
```
