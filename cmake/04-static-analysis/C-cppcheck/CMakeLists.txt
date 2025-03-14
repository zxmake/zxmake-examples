cmake_minimum_required (VERSION 3.5)

project(cppcheck_analysis)

# 添加自定义的 cmake 模块路径
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules
                      ${CMAKE_MODULE_PATH})

# 查找 cppcheck
find_package(CppCheck)

# 在 add_subdirectory 添加子项目之前需要先做静态分析
set (ALL_ANALYSIS_TARGETS)

# 添加子项目
add_subdirectory(subproject1)
add_subdirectory(subproject2)

# 添加 analysis target, 这样 `make analysis` 就会触发全部编译
if( CppCheck_FOUND )
    add_custom_target(analysis)
    ADD_DEPENDENCIES(analysis ${ALL_ANALYSIS_TARGETS})
    set_target_properties(analysis PROPERTIES EXCLUDE_FROM_ALL TRUE)
    message("analysis analysis targets are ${ALL_ANALYSIS_TARGETS}")
endif()
