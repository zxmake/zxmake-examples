cmake_minimum_required(VERSION 3.5)

project(hello_library)

############################################################
# 构建静态库
############################################################

add_library(hello_library STATIC 
    src/hello.cc
)

# 作用域含义如下:
#   PRIVATE -> 目录仅添加到此目标的 include 目录中
#   INTERFACE -> 目录添加到链接此库的任何目标的 include 目录中
#   PUBLIC -> 包含在此库中, 也包含在链接此库的任何目标 include 目录中
target_include_directories(hello_library
    PUBLIC 
        ${PROJECT_SOURCE_DIR}/include
)


############################################################
# 构建可执行程序
############################################################

add_executable(hello_binary 
    src/main.cc
)

target_link_libraries( hello_binary
    PRIVATE 
        hello_library
)
