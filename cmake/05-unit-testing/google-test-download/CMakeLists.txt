cmake_minimum_required(VERSION 3.5)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set the project name
project (google_test_example)

# Add an library for the example classes
add_library(example_google_test 
    reverse.cc
    palindrome.cc
)


#############################################
# Unit tests

add_subdirectory(3rd_party/google-test)

# enable CTest testing
enable_testing()

# Add a testing executable
add_executable(unit_tests unit_tests.cc)

target_link_libraries(unit_tests
    example_google_test
    GTest::GTest 
    GTest::Main
)

add_test(test_all unit_tests)
