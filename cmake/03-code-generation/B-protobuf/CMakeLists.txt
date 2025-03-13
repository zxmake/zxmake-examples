cmake_minimum_required(VERSION 3.5)

project (protobuf_example)

# 查找系统中的 protobuf 库
find_package(Protobuf REQUIRED)

# 检查 protobuf 库是否存在
if(PROTOBUF_FOUND)
    message ("protobuf found")
else()
    message (FATAL_ERROR "Cannot find Protobuf")
endif()

# 生成 *.pb.h 和 *.pb.cc
PROTOBUF_GENERATE_CPP(PROTO_SRCS PROTO_HDRS AddressBook.proto)

# 打印生成 *.pb.h 和 *.pb.cc
message ("PROTO_SRCS = ${PROTO_SRCS}")
message ("PROTO_HDRS = ${PROTO_HDRS}")

# 创建二进制
add_executable(protobuf_example
    main.cc
    ${PROTO_SRCS}
    ${PROTO_HDRS})

# 给二进制添加头文件选项
target_include_directories(protobuf_example
    PUBLIC
    ${PROTOBUF_INCLUDE_DIRS}
    ${CMAKE_CURRENT_BINARY_DIR}
)

# 给二进制添加链接选项
target_link_libraries(protobuf_example
    PUBLIC
    ${PROTOBUF_LIBRARIES}
)
