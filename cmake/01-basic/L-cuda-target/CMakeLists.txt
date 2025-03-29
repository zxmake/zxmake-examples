# 指定支持的 cmake 最低版本
# $ cmake --version
cmake_minimum_required(VERSION 3.5)

# 设置项目名
project (cmake-basic-cuda-target)

# 生成 compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 导入 cuda 包
find_package(CUDA REQUIRED)
message(STATUS "cuda version: " ${CUDA_VERSION_STRING})
include_directories(${CUDA_INCLUDE_DIRS})

cuda_add_executable(cuda_target src/kernel.cu src/main.cc)
target_link_libraries(cuda_target ${CUDA_LIBRARIES})
