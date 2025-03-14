cmake_minimum_required (VERSION 3.5)

project(cppcheck_analysis)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 添加自定义模块
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules
                      ${CMAKE_MODULE_PATH})

find_package(CppCheck)

add_subdirectory(subproject1)
add_subdirectory(subproject2)
