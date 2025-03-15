cmake_minimum_required(VERSION 3.5)

project (boost_unit_test)


# 查找包含 unit_test_framework 的 Boost 1.46.1
find_package(Boost 1.46.1 REQUIRED COMPONENTS unit_test_framework)

# 创建测试用的 library
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
# 单元测试

# 启用 CTest testing
enable_testing()

# 创建一个测试用的可执行程序
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
