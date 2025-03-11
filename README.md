# zxmake-examples

## Examples

* **bazel-cross-build**:
  * **custom-toolchain**: Cross-compilation implemented with a custom toolchain.
  * **hermetic_cc_toolchain**: Implemented ARM cross-compilation using the [zig toolchain](https://github.com/uber/hermetic_cc_toolchain)
  * **toolchains_arm_gnu**: ARM cross-compilation using the packaged [toolchain](https://github.com/hexdae/toolchains_arm_gnu)

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

## Reference

[1] [cmake-examples](https://github.com/ttroy50/cmake-examples)
[2] [rules-cuda-examples](https://github.com/bazel-contrib/rules_cuda/tree/main/examples)
