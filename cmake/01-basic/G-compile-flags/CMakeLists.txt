cmake_minimum_required(VERSION 3.5)

# 设置默认的 C++ 编译参数
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DEX2" CACHE STRING "Set C++ Compiler Flags" FORCE)

project (compile_flags)

# 构建二进制
add_executable(cmake_examples_compile_flags main.cc)

target_compile_definitions(cmake_examples_compile_flags 
    PRIVATE EX3
)
