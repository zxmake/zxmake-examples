cmake_minimum_required(VERSION 3.5)

project(hello_library)

############################################################
# 创建动态库
############################################################

add_library(hello_library SHARED 
    src/hello.cc
)
add_library(hello::library ALIAS hello_library)

target_include_directories(hello_library
    PUBLIC 
        ${PROJECT_SOURCE_DIR}/include
)

############################################################
# 创建可执行程序
############################################################

add_executable(hello_binary
    src/main.cc
)

target_link_libraries( hello_binary
    PRIVATE 
        hello::library
)
