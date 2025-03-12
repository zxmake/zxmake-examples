project (sublibrary2)

# 添加接口库, 不包含实际源文件
add_library(${PROJECT_NAME} INTERFACE)

# 为库添加别名sub::lib2，方便后续引用
add_library(sub::lib2 ALIAS ${PROJECT_NAME})

# 设置库的头文件包含目录，使得使用该库的其他项目可以找到头文件
# INTERFACE 关键字表示这些设置仅对依赖此接口库的目标有效
target_include_directories(${PROJECT_NAME}
    INTERFACE
        ${PROJECT_SOURCE_DIR}/include
)
