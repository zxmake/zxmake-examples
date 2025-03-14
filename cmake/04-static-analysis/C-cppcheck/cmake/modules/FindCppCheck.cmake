# 查找 cppcheck 可执行文件
#
# This module defines
#  CppCheck_FOUND, if false, do not try to link to cppcheck --- if (CppCheck_FOUND)
#  CPPCHECK_BIN, where to find cppcheck
#
# Exported argumets include
#   CPPCHECK_THREADS
#   CPPCHECK_ARG
#
# find the cppcheck binary
find_program(CPPCHECK_BIN NAMES cppcheck)

message(STATUS "CPPCHECK_BIN: ${CPPCHECK_BIN}")

#
# Arguments are 
# -j use multiple threads (and thread count)
# --quite only show errors / warnings etc
# --error-exitcode The code to exit with if an error shows up
# --enabled  Comma separated list of the check types. Can include warning,performance,style
# Note nightly build on earth changes error-exitcode to 0
#
# CACHE 表示这是一个缓存变量存储在 CMakeCache.txt 文件中, 以便在多次构建中保存其值
set (CPPCHECK_THREADS "-j 4" CACHE STRING "The -j argument to have cppcheck use multiple threads / cores")

set (CPPCHECK_ARG "${CPPCHECK_THREADS}" CACHE STRING "The arguments to pass to cppcheck. If set will overwrite CPPCHECK_THREADS")

message(STATUS "CPPCHECK_THREADS: ${CPPCHECK_THREADS}")
message(STATUS "CPPCHECK_ARG: ${CPPCHECK_ARG}")

# handle the QUIETLY and REQUIRED arguments and set YAMLCPP_FOUND to TRUE if all listed variables are TRUE
#
# 查找和验证 cppcheck 工具是否已经安装, 并设置对应的变量
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(
    CppCheck
    DEFAULT_MSG 
    CPPCHECK_BIN
    CPPCHECK_THREADS
    CPPCHECK_ARG)

mark_as_advanced(
    CPPCHECK_BIN
    CPPCHECK_THREADS
    CPPCHECK_ARG)
