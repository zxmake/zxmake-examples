# README

## 前言

本示例展示了如何调用 Clang Format 来检查您的源代码是否符合您的代码风格指南。

此示例中包含的文件如下：

```bash
$ tree
.
├── .clang-format
├── CMakeLists.txt
├── cmake
│   ├── modules
│   │   ├── clang-format.cmake
│   │   └── FindClangFormat.cmake
│   └── scripts
│       └── clang-format-check-changed
├── subproject1
│   ├── CMakeLists.txt
│   └── main1.cpp
└── subproject2
    ├── CMakeLists.txt
    └── main2.cpp
```

* `.clang-format`：描述代码风格指南的文件
* `CMakeLists.txt`：顶层 CMakeLists.txt 文件
* `cmake/modules/clang-format.cmake`： 设置格式化目标的脚本
* `cmake/modules/FindClangFormat.cmake`：查找 clang-format 可执行文件的脚本
* `cmake/scripts/clang-format-check-changed.py`：检查 Git 中已更改文件是否符合代码风格的辅助脚本
* `cmake/scripts/clang-format-check-changed`：上述脚本的旧的简化版本
* `subproject1/CMakeLists.txt`：子项目 1 的 CMake 配置
* `subproject1/main1.cc`：子项目 1 的源代码，无风格错误
* `subproject2/CMakeLists.txt`：子项目 2 的 CMake 配置
* `subproject2/main1.cc`：子项目 2 的源代码，包含风格错误

## clang-format

clang-format 可以扫描源文件，查找并根据您的公司代码风格指南对其进行格式化。虽然有一些内置的默认样式，但您也可以使用名为 `.clang-format` 的自定义文件来设置样式指南。例如，本仓库中的 `.clang-format` 文件片段如下：

```plaintext
Language:        Cpp
# BasedOnStyle:  LLVM
AccessModifierOffset: -4
AlignAfterOpenBracket: Align
AlignConsecutiveAssignments: false
AlignConsecutiveDeclarations: false
```

> 这个例子中的样式基于 `.clang-foramt` 文件，你也可以通过编译 `cmake/modules/clang-format.cmake` 文件，并将 `-style=file` 更改为所需的央视来更改此设置。
