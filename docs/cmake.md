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

## 安装

CMake 提供了添加 `make install` 目标的能力，允许用户安装二进制文件、库和其他文件。基本的安装位置由变量 CMAKE_INSTALL_PREFIX 控制，可以在调用 cmake 时添加 `cmake .. -DCMAKE_INSTALL_PREFIX=/install/location` 来设置。

安装的文件由 `install()` 函数控制：

```cmake
# 将 cmake_examples_inst_bin 目标生成的二进制文件安装到 ${CMAKE_INSTALL_PREFIX}/bin 目录
install (TARGETS cmake_examples_inst_bin
    DESTINATION bin)

# 将 cmake_examples_inst 目标生成的共享库安装到 ${CMAKE_INSTALL_PREFIX}/lib 目录
install (TARGETS cmake_examples_inst
    LIBRARY DESTINATION lib)
```

### 1. install_manifest.txt

运行 `make install` 后，CMake 会生成一个 install_manifest.txt 文件，其中包含所有已安装文件的详细信息。

### 2. 覆盖默认安装位置

> 默认的安装位置由 `CMAKE_INSTALL_PREFIX` 变量控制，默认值为 `/usr/local`。

也可以为所有用户更换此默认位置，可以在添加任何二进制文件或库之前，在顶层 CMakeLists.txt 中添加以下代码：

```cmake
# 此示例将默认安装位置设置为构建目录下的 install 子目录
if( CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT )
  message(STATUS "Setting default CMAKE_INSTALL_PREFIX path to ${CMAKE_BINARY_DIR}/install")
  set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE STRING "The path to use for make install" FORCE)
endif()
```

### 3. DESTDIR 安装前缀

如果希望暂存安装以确认所有文件都包含在内，make install 目标支持 `DESTDIR` 参数。

```bash
make install DESTDIR=/tmp/stage
```

这将创建安装路径 `${DESTDIR}/${CMAKE_INSTALL_PREFIX}`，在本例中，所有文件将安装在 `/tmp/stage/usr/local` 路径下。

#### 4. 卸载

默认情况下，CMake 不会添加 make uninstall 目标。

要轻松删除本示例中的文件，可以使用以下命令：

```bash
sudo xargs rm < install_manifest.txt
```

## Make 命令细节

```bash
# 清理产出
make clean

# 查看详细信息
make VERBOSE = 1
```
