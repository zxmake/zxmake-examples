cmake_minimum_required(VERSION 3.1)

project (hello_cpp11)

add_executable(hello_cpp11 main.cc)

# set the C++ standard to the appropriate standard for using auto
target_compile_features(hello_cpp11 PUBLIC cxx_auto_type)

# Print the list of known compile features for this version of CMake
message("List of compile features: ${CMAKE_CXX_COMPILE_FEATURES}")
