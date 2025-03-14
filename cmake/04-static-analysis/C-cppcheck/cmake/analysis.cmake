# Make sure cppcheck binary is available
if( NOT CppCheck_FOUND )
    find_package(CppCheck)
endif()

# add a target for CppCheck
# _target - The name of the project that this is for. Will generate ${_target}_analysis 
# _sources - The name of the variable holding the sources list. 
#            This is the name of the variable not the actual list
#
# Macro instead of function to make the PARENT_SCOPE stuff easier
macro(add_analysis _target _sources)
    if( CppCheck_FOUND )

        # 构造 cppcheck_includes, 用于 cppcheck 的 -I 参数
        get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
        foreach(dir ${dirs})
            LIST(APPEND cppcheck_includes "-I${dir}")
        endforeach()
        MESSAGE(STATUS "cppcheck_includes: ${cppcheck_includes}")

        # 将 "${_target}_analysis" 追加到 ALL_ANALYSIS_TARGETS 中, 并将 ALL_ANALYSIS_TARGETS 设置到父级作用域中
        # 这样父级 CMakeLists.txt 文件或其他包含的文件可以访问这个变量
        LIST(APPEND ALL_ANALYSIS_TARGETS "${_target}_analysis")
        set(ALL_ANALYSIS_TARGETS "${ALL_ANALYSIS_TARGETS}" PARENT_SCOPE)
        MESSAGE(STATUS "ALL_ANALYSIS_TARGETS: ${ALL_ANALYSIS_TARGETS}")

        # 构造参数列表存储在 tmp_args 中, 根据 cmake 版本走不同的逻辑
        #
        # This is used to make the command run correctly on the command line.
        # The COMMAND argument expects a list and this does the change
        # I need to check which version works with 2.7
        if (${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VESION} GREATER 2.7)
            separate_arguments(tmp_args UNIX_COMMAND ${CPPCHECK_ARG})
        else ()
            # cmake 2.6 has different arguments 
            string(REPLACE " " ";" tmp_args ${CPPCHECK_ARG})
        endif ()

        # 构造一个用户自定义 target: ${_target}_analysis
        # 并将其从默认的构建目标中排除, 除非使用 make all 或 make ${_target}_analysis 命令
        add_custom_target(${_target}_analysis)
        set_target_properties(${_target}_analysis PROPERTIES EXCLUDE_FROM_ALL TRUE)
        
        # 为自定义的 target 指定一个自定义的构建步骤 (PRE_BUILD 表示在构建目标之前运行)
        add_custom_command(TARGET ${_target}_analysis PRE_BUILD
            WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
            COMMAND ${CPPCHECK_BIN} ${tmp_args} ${cppcheck_includes} ${${_sources}}
            DEPENDS ${${_sources}} # 依赖文件, 如果这些命令发生变化命令就会重新运行
            COMMENT "Running cppcheck: ${_target}"
            VERBATIM # 确保命令参数不被转义
            )
        message("adding cppcheck analysys target for ${_target}")
    endif()

endmacro()
