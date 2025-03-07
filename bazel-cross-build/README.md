# bazel-cross-build

## Reference

> [Cross compiling with Bazel](https://ltekieli.github.io/cross-compiling-with-bazel/)
>
> [bazel-examples](https://github.com/bazelbuild/examples/blob/main/cpp-tutorial/stage1/main/hello-world.cc)
>
> [https://bazel.build/tutorials/ccp-toolchain-config](https://bazel.build/tutorials/ccp-toolchain-config)

## Prepare

```bash
# 安装 bazel
# https://docs.bazel.build/versions/main/install-ubuntu.html
sudo apt install apt-transport-https curl gnupg -y
curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
sudo mv bazel-archive-keyring.gpg /usr/share/keyrings
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list

# 使用固定的版本
sudo apt update && sudo apt install bazel-8.1.1
```

## 正常编译

```bash
# 进入 bazel workspace
cd bazel-cross-build/

# 编译
bazel build //main:hello-world

# 运行
bazel-bin/main/hello-world
```

## 交叉编译

```bash
bazel build //main:hello-world
```

## Bazel 使用技巧

```bash
# --subcommands 可以查看具体的编译命令
bazel build --subcommands //main:hello-world

# 强制重新编译
bazel clean
bazel build //main:hello-world
```
