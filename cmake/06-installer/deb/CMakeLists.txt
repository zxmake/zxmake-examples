cmake_minimum_required(VERSION 3.5)

project(cmake_examples_deb)

# 生成 compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 设置项目版本号
set (deb_example_VERSION_MAJOR 0)
set (deb_example_VERSION_MINOR 2)
set (deb_example_VERSION_PATCH 2)
set (deb_example_VERSION "${deb_example_VERSION_MAJOR}.${deb_example_VERSION_MINOR}.${deb_example_VERSION_PATCH}")


############################################################
# 创建动态库
############################################################

add_library(cmake_examples_deb SHARED src/hello.cc)

target_include_directories(cmake_examples_deb
    PUBLIC
        ${PROJECT_SOURCE_DIR}/include
)
############################################################
# 创建可执行程序
############################################################

add_executable(cmake_examples_deb_bin src/main.cc)

target_link_libraries( cmake_examples_deb_bin
    PUBLIC
        cmake_examples_deb
)

############################################################
# 安装
############################################################

# 二进制
install (TARGETS cmake_examples_deb_bin
    DESTINATION bin)

# 动态库
install (TARGETS cmake_examples_deb
    LIBRARY DESTINATION lib)

# 配置
install (FILES cmake-examples.conf
    DESTINATION etc)

############################################################
# 创建 DEB
############################################################

# Tell CPack to generate a .deb package
set(CPACK_GENERATOR "DEB")

# Set a Package Maintainer.
# This is required
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Thom Troy")

# Set a Package Version
set(CPACK_PACKAGE_VERSION ${deb_example_VERSION})

# Include CPack
include(CPack)
