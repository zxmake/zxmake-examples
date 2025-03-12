project (sublibrary1)

# 添加库文件
add_library(${PROJECT_NAME} src/sublib1.cc)

# 为库添加 sub::lib1 别名, 方便后续引用
add_library(sub::lib1 ALIAS ${PROJECT_NAME})

# 设置库的 includedir, 方便引用该库的其他项目可以找到头文件
target_include_directories( ${PROJECT_NAME}
    PUBLIC ${PROJECT_SOURCE_DIR}/include
)
