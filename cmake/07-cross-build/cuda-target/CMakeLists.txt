# 交叉编译配置
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR "aarch64")

set(CMAKE_C_COMPILER aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER aarch64-linux-gnu-g++)
set(CMAKE_CUDA_COMPILER nvcc)
# 同时会指定链接器为 aarch64-linux-gnu-g++, 避免找不到 c++ 头文件
set(CMAKE_CUDA_HOST_COMPILER aarch64-linux-gnu-g++)

set(CMAKE_FIND_ROOT_PATH "/usr/aarch64-linux-gnu")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# 指定 cmake 要求的最低版本
cmake_minimum_required(VERSION 3.18)

# 设置项目名 (必须要指明 cuda)
project(CUDA_Cross_Compile LANGUAGES CXX CUDA)

# 生成 compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 设置 CUDA 目标架构，例如 Jetson 平台使用 sm_72 或更高版本
set(CMAKE_CUDA_ARCHITECTURES 72)

# # 添加 CUDA 代码
add_executable(my_cuda_program src/main.cc src/kernel.cu)
