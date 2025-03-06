# zxmake-examples

## Docker

* ubuntu 24.04
* bazel v8.1.1
* xmake v3.0.5
* cmake
* clang
* gcc

通过手动触发流水线推送到 docker hub。

```bash
# 搭建 docker 容器
bash scripts/docker.sh build

# 运行 docker 容器
bash scripts/docker.sh run

# 删除 docker 容器及镜像
# bash scripts/docker.sh clear --image
```

## 代码提示

> 需要 clangd 插件。

```bash
# 生成 compile_commands.json
xmake build --all
```
