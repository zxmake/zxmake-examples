# 设置最低支持的 cmake 版本
cmake_minimum_required(VERSION 3.5)

# 设置项目名
project (hello_headers)

# 设置 SOURCES 变量, 包含全部的源文件
set(SOURCES
    src/hello.cc
    src/main.cc
)

# 根据前面定义的 SOURCES 创建二进制
add_executable(hello_headers ${SOURCES})

# 设置编译时的头文件目录, 这些目录将作为 -I/directory/path/ 包含在编译命令中
target_include_directories(hello_headers
    PRIVATE 
        ${PROJECT_SOURCE_DIR}/include
)
