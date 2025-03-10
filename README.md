# zxmake-examples

## Examples

* **bazel-cross-build**：自定义 toolchain 实现的交叉编译
* **bazel-cross-build2**：使用打包好的 [toolchain](https://github.com/hexdae/toolchains_arm_gnu) 实现的 arm 交叉编译

## Docker

* ubuntu 22.04
* bazel v8.1.1
* xmake v3.0.5
* cmake 3.22.1
* clang 14.0.6
* gcc 9.5.0

通过手动触发流水线推送到 docker hub。

```bash
# 搭建 docker 容器
bash scripts/docker.sh build

# 运行 docker 容器
bash scripts/docker.sh run

# 删除 docker 容器及镜像
# bash scripts/docker.sh clear --image
```

## 插件

### 1. 代码提示

需要 clangd 和 clang-format 插件。

```bash
# 生成 compile_commands.json
xmake build --all
```

### 2. Bazel 语法提示

需要安装 Bazel 插件。

## 运行 arm 二进制

```bash
# apt-get install qemu-user-static

cd bazel-cross-build/
bazel build //main:hello-world

# 需要设置 QEMU_LD_PREFIX, 否则会报错:
# qemu-aarch64-static: Could not open '/lib/ld-linux-aarch64.so.1': No such file or directory
# export QEMU_LD_PREFIX=/usr/aarch64-linux-gnu
qemu-aarch64-static ./bazel-bin/main/hello-world
```
