# bazel-cross-build

## Reference

> [使用 Bazel 交叉编译树莓派程序](https://zhuanlan.zhihu.com/p/336907030)
>
> [bazel-examples](https://github.com/bazelbuild/examples/blob/main/cpp-tutorial/stage1/main/hello-world.cc)

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
