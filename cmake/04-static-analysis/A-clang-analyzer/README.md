# README

## scan build

`scan-build` 是 Clang 提供的静态分析工具，它可以在编译 C/C++ 代码时自动检测常见的编程错误，例如：

* **内存泄漏** （Memory Leak）
* **空指针解引用** （Null Pointer Dereference）
* **使用未初始化变量** （Use of Uninitialized Variables）
* **释放后使用（Use-After-Free）**
* **死代码** （Dead Code）
* **逻辑错误** （Logic Errors）

它的工作方式是拦截编译命令，并在代码编译时执行额外的静态分析。

## 直接使用

```bash
$ scan-build -o ./scanbuildout gcc -o main main.cc
scan-build: Using '/usr/lib/llvm-14/bin/clang' for static analysis
main.cc:10:1: warning: Potential leak of memory pointed to by 'ptr' [unix.Malloc]
}
^
main.cc:19:12: warning: Use of memory after it is freed [unix.Malloc]
    return *ptr;  // 释放后访问
           ^~~~
2 warnings generated.
scan-build: Analysis run complete.
scan-build: 2 bugs found.
scan-build: Run 'scan-view /zxmake-examples/cmake/04-static-analysis/A-clang-analyzer/scanbuildout/2025-03-15-175822-52834-1' to examine bug reports.
```
