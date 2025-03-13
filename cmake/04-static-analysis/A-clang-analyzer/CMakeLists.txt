cmake_minimum_required (VERSION 3.5)

project(cppcheck_analysis)

# 推荐启动 DEBUG 模式添加调试符号
set(CMAKE_BUILD_TYPE Debug)

# 生成 compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 添加子项目
add_subdirectory(subproject1)
add_subdirectory(subproject2)
