cmake_minimum_required (VERSION 3.5)

project(clang-format)

# 添加自定义 CMake 模块的搜索路径
# * CMAKE_MODULE_PATH 变量用于指定 CMake 再查找模块文件 (.cmake 文件) 时的搜索路径
# * 模块文件通常包含一些可重用的 CMake 代码, 例如自定义的 find_package 模块或一些常用的宏或函数
#
# 因为 CMake 自身没提供 FindClangFormat.cmake, 所以我们
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules
                      ${CMAKE_MODULE_PATH})

# 添加子项目
add_subdirectory(subproject1)
add_subdirectory(subproject2)

# 设置变量
set(CLANG_FORMAT_BIN_NAME clang-format)
set(CLANG_FORMAT_EXCLUDE_PATTERNS  "build/" ${CMAKE_BINARY_DIR})

# 打印变量
message(STATUS "CLANG_FORMAT_BIN_NAME: ${CLANG_FORMAT_BIN_NAME}")
message(STATUS "CLANG_FORMAT_EXCLUDE_PATTERNS: ${CLANG_FORMAT_EXCLUDE_PATTERNS}")

find_package(ClangFormat)
