cmake_minimum_required(VERSION 3.5)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

project (catch2_unit_test)

set(CMAKE_CXX_STANDARD 11)

# add the CMakeFile that defines catch2
add_subdirectory(3rd_party/catch2)

# Add an library for the example classes
add_library(example_unit_test
    reverse.cc
    palindrome.cc
)


#############################################
# Unit tests

# enable CTest testing
enable_testing()

# Add a testing executable
add_executable(unit_tests unit_tests.cc)

target_link_libraries(unit_tests
    example_unit_test
    Catch2::Test
)

add_test(test_all unit_tests)
