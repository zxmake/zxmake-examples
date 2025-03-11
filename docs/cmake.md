# CMake

## 变量

CMake语法指定了许多变量，这些变量可用于帮助在项目或源代码树中找到有用的目录。其中一些包括：

|            变量            |                  信息                  |
| :------------------------: | :------------------------------------: |
|     `CMAKE_SOURCE_DIR`     |                根源目录                |
| `CMAKE_CURRENT_SOURCE_DIR` | 如果使用子项目和目录，则为当前源目录。 |
|    `PROJECT_SOURCE_DIR`    |        当前CMake项目的源目录。         |
|     `CMAKE_BINARY_DIR`     |  运行cmake命令的根目录或顶级文件夹。   |
| `CMAKE_CURRENT_BINARY_DIR` |         您当前所在的构建目录。         |
|    `PROJECT_BINARY_DIR`    |          当前项目的构建目录。          |

## 生成 binary 规则

```cmake
# 创建一个变量，包含所有要编译的 cpp 文件
set(SOURCES
    src/hello.cc
    src/main.cpp
)

add_executable(${PROJECT_NAME} ${SOURCES})
```

## 添加头文件目录

```cmake
target_include_directories(target
    PRIVATE
        ${PROJECT_SOURCE_DIR}/include
)
```

## Make 命令细节

```bash
# 清理产出
make clean

# 查看详细信息
make VERBOSE = 1
```
