cmake_minimum_required(VERSION 3.5)

project(cmake_examples_install)

############################################################
# 创建动态库
############################################################

add_library(cmake_examples_inst SHARED
    src/hello.cc
)

target_include_directories(cmake_examples_inst
    PUBLIC 
        ${PROJECT_SOURCE_DIR}/include
)

############################################################
# 创建可执行程序
############################################################

add_executable(cmake_examples_inst_bin
    src/main.cc
)

target_link_libraries( cmake_examples_inst_bin
    PRIVATE 
        cmake_examples_inst
)

############################################################
# 安装
############################################################

# Binaries
install (TARGETS cmake_examples_inst_bin
    DESTINATION bin)

# Library
install (TARGETS cmake_examples_inst
    LIBRARY DESTINATION lib)

# Header files
install(DIRECTORY ${PROJECT_SOURCE_DIR}/include/ 
    DESTINATION include)

# Config
install (FILES cmake-examples.conf
    DESTINATION etc)
