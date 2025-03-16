# 交叉编译选项
# 官方文档: https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#id16
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(triple arm-linux-gnueabihf)

set(CMAKE_C_COMPILER clang)
# set(CMAKE_C_COMPILER_TARGET ${triple})
set(CMAKE_C_COMPILER_TARGET "aarch64-linux-gnu")
set(CMAKE_CXX_COMPILER clang++)
# set(CMAKE_CXX_COMPILER_TARGET ${triple})
set(CMAKE_CXX_COMPILER_TARGET "aarch64-linux-gnu")

# 指定支持的 cmake 最低版本
# $ cmake --version
cmake_minimum_required(VERSION 3.5)

# 设置项目名
project (official-using-clang)

# 生成 compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 创建可执行文件
add_executable(official-using-clang main.cc)
