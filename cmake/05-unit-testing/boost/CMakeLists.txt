cmake_minimum_required(VERSION 3.5)

project (boost_unit_test)


# find a boost install with the libraries unit_test_framework
find_package(Boost 1.46.1 REQUIRED COMPONENTS unit_test_framework)

# Add an library for the example classes
add_library(example_boost_unit_test
    reverse.cc
    palindrome.cc
)

target_include_directories(example_boost_unit_test
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(example_boost_unit_test
    PUBLIC
        Boost::boost
)

#############################################
# Unit tests

# enable CTest testing
enable_testing()

# Add a testing executable
add_executable(unit_tests unit_tests.cc)

target_link_libraries(unit_tests
    example_boost_unit_test
    Boost::unit_test_framework
)

target_compile_definitions(unit_tests
    PRIVATE
        BOOST_TEST_DYN_LINK
)

add_test(test_all unit_tests)
