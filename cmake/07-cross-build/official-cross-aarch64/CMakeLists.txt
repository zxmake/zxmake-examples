# 交叉编译选项
# * 官方文档: https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#id14
# * 参考文档: https://discourse.cmake.org/t/linux-cross-compile-x64-to-aarch64/1752/3
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# 指定交叉编译器
set(CMAKE_C_COMPILER /usr/bin/aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER /usr/bin/aarch64-linux-gnu-g++)

# 指定交叉编译时的系统根目录, 我们这里暂时不用设置
# set(CMAKE_SYSROOT /home/devel/rasp-pi-rootfs)
# set(CMAKE_STAGING_PREFIX /home/devel/stage)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# 指定支持的 cmake 最低版本
# $ cmake --version
cmake_minimum_required(VERSION 3.5)

# 设置项目名
project (official-cross-aarch64)

# 生成 compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 创建可执行文件
add_executable(official-cross-aarch64 main.cc)
