cmake_minimum_required(VERSION 3.5)

project (third_party_include)

# find a boost install with the libraries filesystem and system
find_package(Boost 1.46.1 REQUIRED COMPONENTS filesystem system)

# 检查 boost 是否存在
if(Boost_FOUND)
    message ("boost found")
else()
    message (FATAL_ERROR "Cannot find Boost")
endif()

# 构建二进制
add_executable(third_party_include main.cc)

# 给 third_party_include 添加 boost 库链接选项
target_link_libraries( third_party_include
    PRIVATE
        Boost::filesystem
)
