# 指定支持的 cmake 最低版本
# $ cmake --version
cmake_minimum_required(VERSION 3.5)

# 设置项目名
project (hello_cmake)

# 生成 compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 创建可执行文件
add_executable(hello_cmake main.cc)
