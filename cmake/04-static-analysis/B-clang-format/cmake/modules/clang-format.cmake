# A CMake script to find all source files and setup clang-format targets for them

# 定义 C++ 源文件的扩展名并通过 GLOB_RECURSE 搜索到所有的源文件, 记录到 ALL_SOURCE_FILES 里
set(CLANG_FORMAT_CXX_FILE_EXTENSIONS ${CLANG_FORMAT_CXX_FILE_EXTENSIONS} *.cpp *.h *.cxx *.hxx *.hpp *.cc *.ipp)
file(GLOB_RECURSE ALL_SOURCE_FILES ${CLANG_FORMAT_CXX_FILE_EXTENSIONS})
message(STATUS "ALL_SOURCE_FILES: ${ALL_SOURCE_FILES}")

# 定义要排除的常见构建文件夹模式
set(CLANG_FORMAT_EXCLUDE_PATTERNS ${CLANG_FORMAT_EXCLUDE_PATTERNS} "/CMakeFiles/")

# 遍历所有源文件, 排除匹配排除模式的文件, 从 ${ALL_SOURCE_FILES} 中删除
foreach (SOURCE_FILE ${ALL_SOURCE_FILES})
    foreach (EXCLUDE_PATTERN ${CLANG_FORMAT_EXCLUDE_PATTERNS})
        # 查找文件中是否出现 CLANG_FORMAT_EXCLUDE_PATTERNS 中包含的字符串
        string(FIND ${SOURCE_FILE} ${EXCLUDE_PATTERN} EXCLUDE_FOUND) 
        if (NOT ${EXCLUDE_FOUND} EQUAL -1) 
            MESSAGE(STATUS "remove file [${SOURCE_FILE}] that need to be formatted")
            list(REMOVE_ITEM ALL_SOURCE_FILES ${SOURCE_FILE})
        endif () 
    endforeach ()
endforeach ()

# 打印需要格式化的文件
message(STATUS "ALL_SOURCE_FILES: ${ALL_SOURCE_FILES}")

# 添加一个自定义的构建目标
add_custom_target(format
    # COMMENT 用于再构建过程中提供额外的信息或说明
    COMMENT "Running clang-format to change files"
    COMMAND ${CLANG_FORMAT_BIN}
    -style=file
    -i
    ${ALL_SOURCE_FILES}
)

# 检查代码是否遵循 clang-format 格式化规范
add_custom_target(format-check
    COMMENT "Checking clang-format changes"
    # Use ! to negate the result for correct output
    # 使用 ! 来否定命令的结果, 以保证正确的输出, 相当于结果不能出现 "replacement offset"
    COMMAND !
    ${CLANG_FORMAT_BIN}
    -style=file
    -output-replacements-xml
    ${ALL_SOURCE_FILES}
    | grep -q "replacement offset" 
)

# 获取当前 CMake 脚本所在的路径, 主要是为了拼接后续的 clang-format-check-changed.py 脚本
get_filename_component(_clangcheckpath ${CMAKE_CURRENT_LIST_FILE} PATH)

set(CHANGED_FILE_EXTENSIONS ".cc")
foreach(EXTENSION ${CLANG_FORMAT_CXX_FILE_EXTENSIONS})
    set(CHANGED_FILE_EXTENSIONS "${CHANGED_FILE_EXTENSIONS},${EXTENSION}" )
endforeach()

set(EXCLUDE_PATTERN_ARGS)
foreach(EXCLUDE_PATTERN ${CLANG_FORMAT_EXCLUDE_PATTERNS})
    list(APPEND EXCLUDE_PATTERN_ARGS "--exclude=${EXCLUDE_PATTERN}")
endforeach()

# 调用 clang-format-check-changed.py 脚本检查 git 是否有文件修改了
add_custom_target(format-check-changed
    COMMENT "Checking changed files in git"
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMAND ${_clangcheckpath}/../scripts/clang-format-check-changed.py 
    --file-extensions \"${CHANGED_FILE_EXTENSIONS}\"
    ${EXCLUDE_PATTERN_ARGS}
    --clang-format-bin ${CLANG_FORMAT_BIN}
)
