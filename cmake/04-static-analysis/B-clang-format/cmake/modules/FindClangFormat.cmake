# 查找 clang-format 脚本
# 以用户自定义变量 CLANG_FORMAT_BIN_NAME 为准
if(NOT CLANG_FORMAT_BIN_NAME)
	set(CLANG_FORMAT_BIN_NAME clang-format)
endif()

# 优先使用用户自定义的查找路径
if(CLANG_FORMAT_ROOT_DIR)
    find_program(CLANG_FORMAT_BIN 
        NAMES
        ${CLANG_FORMAT_BIN_NAME}
        PATHS
        "${CLANG_FORMAT_ROOT_DIR}"
        NO_DEFAULT_PATH)
endif()

# 查找可执行程序 clang-format
# * CLANG_FORMAT_BIN 是一个变量名, 用于存储查找到的 clang-format 可执行文件的路径
# * NAMES 后面紧跟着要查找的程序名称, 这是我们之前自定义的
find_program(CLANG_FORMAT_BIN NAMES ${CLANG_FORMAT_BIN_NAME})

# FIND_PACKAGE_HANDLE_STANDARD_ARGS 是 CMake 提供的一个用于简化和标准化查找包 (库、工具等) 后状态检查的函数
# * ClangFormat: 包的逻辑名称, 用于标识查找的包
# * DEFAULT_MSG: 可选参数, 查找不到包时使用默认的错误信息
# * CLANG_FORMAT_BIN: 需要检查的变量列表, 这个变量是 find_program 查找到后定义的变量
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(
    ClangFormat
    DEFAULT_MSG 
    CLANG_FORMAT_BIN)

# 标记为高级变量, 在 ccmake 或其他 CMake GUI 中，CLANG_FORMAT_BIN 将默认隐藏
mark_as_advanced(
    CLANG_FORMAT_BIN)

if(ClangFormat_FOUND)
    # 引用用户自定义的 clang-format.cmake 脚本来搜索全部的 Source Files 并运行 clang-format
    include(clang-format)
else()
    # 查找不到 clang-format 报错退出
    message(FATAL_ERROR "clang-format not found. Not setting up format targets")
endif()
