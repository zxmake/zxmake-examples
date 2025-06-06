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
cd bazel-cross-build/custom-toolchain

# 编译
bazel build //main:hello-world

# 运行
bazel-bin/main/hello-world
```

## 交叉编译

> 旧机制通过设置 `--crosstool_top` 标志来选择工具链，我们使用 platforms 参数来指定目标平台。
>
> 相关的讨论如下：
> [https://github.com/bazelbuild/bazel/issues/7260](https://github.com/bazelbuild/bazel/issues/7260)

```bash
bazel build --platforms=//platforms:aarch64_linux //main:hello-world
```

## Bazel 使用技巧

```bash
# --subcommands 可以查看具体的编译命令
bazel build --subcommands //main:hello-world

# 强制重新编译
bazel clean
bazel build //main:hello-world
```

## Cuda 交叉编译

> 需要下载 Nvidia 的 cuda 交叉编译工具链, 否则会报错 cudart 找不到。
>
> <https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/cross-linux-aarch64/>

```bash
# ubuntu 2004
cd /tmp

wget https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/cross-linux-aarch64/cuda-driver-cross-aarch64-11-8_11.8.89-1_all.deb
wget https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/cross-linux-aarch64/cuda-cccl-cross-aarch64-11-8_11.8.89-1_all.deb
wget https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu2004/cross-linux-aarch64/cuda-cudart-cross-aarch64-11-8_11.8.89-1_all.deb

sudo dpkg -i cuda-driver-cross-aarch64-11-8_11.8.89-1_all.deb
sudo apt install cuda-driver-cross-aarch64-11-8
sudo dpkg -i cuda-cccl-cross-aarch64-11-8_11.8.89-1_all.deb
sudo apt install cuda-cccl-cross-aarch64-11-8
sudo dpkg -i cuda-cudart-cross-aarch64-11-8_11.8.89-1_all.deb
sudo apt install cuda-cudart-cross-aarch64-11-8
```

cuda 交叉编译最核心的步骤在于修改了 `-ccbin=/usr/bin/aarch64-linux-gnu-gcc` 参数。

```bash
# 举个例子
nvcc -c -I. -I/usr/local/cuda/include --std c++17 -I/opt/toolchain/orin/include -I/opt/toolchain/orin/cuda-11.4/targets/aarch64-linux/include -I/opt/toolchain/orin/include/aarch64-linux-gnu --use_fast_math -Xcompiler -g0 -DNDEBUG -Xcompiler -ffunction-sections -Xcompiler -fdata-sections -Xcompiler -fPIC --expt-relaxed-constexpr --extended-lambda -m64 -ccbin=/usr/bin/aarch64-linux-gnu-gcc -gencode arch=compute_60,code=compute_60 -gencode arch=compute_60,code=[sm_60,sm_61,sm_62] -gencode arch=compute_70,code=compute_70 -gencode arch=compute_70,code=[sm_70,sm_72,sm_75] -gencode arch=compute_80,code=compute_80 -gencode arch=compute_80,code=[sm_80,sm_86,sm_87] -o upsampling_plugin.cu.o upsampling_plugin.cu
```
