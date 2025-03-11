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

## 构建类型

CMake 提供了多种内置的构建配置，用于编译项目。这些配置指定了代码的优化级别以及是否包含调试信息。以下是 CMake 支持的几种构建类型：

* **​Release**：添加 `-O3 -DNDEBUG` 标志到编译器，用于最终用户的发布版本，优化代码以提高执行速度和效率，不保留调试信息或仅保留极少的调试信息。
* **​Debug**：添加 `-g` 标志，用于调试。不优化代码，保留完整的调试信息，使得开发者可以进行调试，找出程序中的错误。
* **​MinSizeRel**：添加 `-Os -DNDEBUG` 标志，用于生成尽可能小的可执行文件。优化代码以减少可执行文件的大小，不保留调试信息或仅保留极少的调试信息。
* **​RelWithDebInfo**：添加 `-O2 -g -DNDEBUG` 标志，提供了一种中间方案，旨在结合 Release 的优化和 Debug 的调试信息。优化代码，同时保留足够的调试信息，便于调试优化后的代码。

### 1. 通过命令行设置

可以在运行 cmake 命令时通过 -DCMAKE_BUILD_TYPE 参数来设置构建类型。

```bash
cmake -DCMAKE_BUILD_TYPE=Release ..
```

### 2. 设置默认构建类型

如果未指定构建类型，CMake 默认使用 Debug 构建类型。可以通过在顶层 CMakeLists.txt 文件中添加以下代码来设置默认构建类型：

```cmake
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message("Setting build type to 'RelWithDebInfo' as none was specified.")
  set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()
```

## 添加编译参数

CMake 支持两种方式添加编译参数：

* `target_compile_definitions()` 和 `target_compile_options()` 函数
* `CMAKE_C_FLAGS` 和 `CMAKE_CXX_FLAGS` 函数

### 1. 添加宏定义

```bash
# 相当于添加 -DEX3 定义
# 如果目标是库, 并且选择了 PUBLIC 或 INTERFACE 作用域, 则改定义也将包含在链接该目标的任何可执行文件中
target_compile_definitions(cmake_examples_compile_flags
    PRIVATE EX3
)
```

### 2. 设置默认 C++ flags

`CMAKE_CXX_FLAGS` 的默认值为空或包含生成类型的相应标志。要设置其他默认编译标志，可以将以下内容添加到顶级 CMakeLists.txt 中：

```cmake
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DEX2" CACHE STRING "Set C++ Compiler Flags" FORCE)
```

除此之外：

* **CMAKE_C_FLAGS**: 设置 C 编译器 flags
* **CMAKE_LINKER_FLAGS**： 设置链接器 flags

也可以在命令行设置：

```bash
cmake .. -DCMAKE_CXX_FLAGS="-DEX3"
```

## 引用三方库

几乎所有成熟的项目都需要包含第三方库、头文件或程序。CMake 通过 `find_package()` 函数支持查找这些工具的路径。该函数会在 `CMAKE_MODULE_PATH` 中列出的文件夹中搜索格式为 `"FindXXX.cmake"` 的 CMake 模块。在 Linux 上，默认搜索路径包括 `/usr/share/cmake/Modules`。

### 1. 查找包

查找 Boost 的例子如下：

```bash
# Boost -> 库名
# 1.46.1 -> 要查找的 Boost 最低版本
# REQUIRED -> 表示此库是必需的, 找不到会失败
# COMPONENTS -> 要查找的库的组件
find_package(Boost 1.46.1 REQUIRED COMPONENTS filesystem system)
```

### 2. 导出的变量

大多数包含的包会设置一个变量 XXX_FOUND，用于检查系统上是否有该包。

在上面的例子中，变量为 Boost_FOUND：

```cmake
if(Boost_FOUND)
    message ("boost found")
    include_directories(${Boost_INCLUDE_DIRS})
else()
    message (FATAL_ERROR "Cannot find Boost")
endif()
```

> 除此之外，`Boost_INCLUDE_DIRS` 变量用于表示头文件的路径。

### 3. 别名 / 导入目标

在 Boost 的情况下，所有目标都使用 `Boost::` 标识符导出，然后是子系统的名称。例如，您可以使用：

* **Boost::boost**： 用于仅包含头文件的库
* **Boost::system**： 用于 Boost 系统库
* **Boost::filesystem**： 用于文件系统库

与自己的目标一样，这些目标包括它们的依赖项，因此链接到 `Boost::filesystem` 会自动添加 `Boost::boost` 和 `Boost::system` 依赖项。

要链接到导入的目标，可以使用以下命令：

```cmake
target_link_libraries(third_party_include
    PRIVATE
        Boost::filesystem
)
```

### 4. 非导入目标

虽然大多数现代库使用导入目标，但并非所有模块都已更新。在某些情况下，如果库未更新，您通常会找到以下变量：

* **xxx_INCLUDE_DIRS**： 指向库包含目录的变量
* **xxx_LIBRARY**： 指向库路径的变量

然后，您可以将这些变量添加到 `target_include_directories` 和 `target_link_libraries` 中：

```cmake
# 包含 Boost 头文件
target_include_directories(third_party_include
    PRIVATE ${Boost_INCLUDE_DIRS}
)

# 链接 Boost 库
target_link_libraries(third_party_include
    PRIVATE
        ${Boost_SYSTEM_LIBRARY}
        ${Boost_FILESYSTEM_LIBRARY}
)
```

## 切换工具链

CMake 提供了选项来控制编译和链接代码的程序：

* **CMAKE_C_COMPILER**: 编译 C 代码的程序
* **CMAKE_CXX_COMPILER**: 编译 C++ 代码的程序
* **CMAKE_LINKER**: 链接二进制文件的程序

例子：

```bash
cmake .. -DCMAKE_C_COMPILER=clang-3.6 -DCMAKE_CXX_COMPILER=clang++-3.6
```

## Make 命令细节

```bash
# 清理产出
make clean

# 查看详细信息
make VERBOSE = 1
```
