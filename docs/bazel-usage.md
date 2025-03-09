# bazel-usage

```
# 查看外部库保存的路径, 进入 external 就是外部库路径
$ bazel info output_base
/root/.cache/bazel/_bazel_root/a156044b6616ba673f1f0498e2d4f77b

# 下载依赖
$ bazel fetch //...
```
