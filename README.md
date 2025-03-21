# zxmake-examples

## Examples

* **bazel**:
  * **01-cross-build**:
    * **custom-toolchain**: Cross-compilation implemented with a custom toolchain.
    * **hermetic_cc_toolchain**: Implemented ARM cross-compilation using the [zig toolchain](https://github.com/uber/hermetic_cc_toolchain)
    * **toolchains_arm_gnu**: ARM cross-compilation using the packaged [toolchain](https://github.com/hexdae/toolchains_arm_gnu)
  * **02-cuda-target**:
    * **basic**: Basic example of using CUDA in Bazel.
    * **basic-macros**: Basic example of using CUDA in Bazel with macros.
    * **cublas**: Example of using cuBLAS in Bazel.
    * **if-cuda**: Example of using conditional compilation in Bazel with CUDA.
    * **rdc**: Example of using RDC in Bazel.
    * **thrust**: Example of using Thrust in Bazel.

* **cmake**:
  * **01-basic**: Basic example of using CMake.
  * **02-sub-projects**: Example of using sub-projects in CMake.
  * **03-code-generation**: Example of using code generation (configure files / protobuf) in CMake.
  * **04-static-analysis**: Example of using static analysis (clang-analyzer / clang-format / cppcheck) in CMake.
  * **05-unit-testing**: Example of using unit testing (boost_unit_test / catch2 / gtest) in CMake.
  * **06-installer**: Example of using installer (Deb) in CMake.
  * **07-cross-build**: Example of using cross-compilation in CMake.

* **xmake**:
  * **01-basic**: Basic example of using xmake.
  * **02-cross-build**: Example of using cross-compilation (aarch64-none-linux-gnu / arm-none-linux-gnueabihf / clang-target / g++-aarch64-linux-gnu / llvm14 / muslcc / zig) in xmake.

## Docker

* ubuntu 22.04
* cuda 11.8
* bazel v8.1.1
* xmake v3.0.5
* cmake 3.22.1
* clang 14.0.6
* gcc 9.5.0
* zig 0.14.0
* cuda cross build environment

```bash
# Build and Run the Docker container
make docker

# Remove the Docker container and image
# bash scripts/docker.sh clear --image
```

## Reference

[1] [cmake-examples](https://github.com/ttroy50/cmake-examples)

[2] [rules-cuda-examples](https://github.com/bazel-contrib/rules_cuda/tree/main/examples)
