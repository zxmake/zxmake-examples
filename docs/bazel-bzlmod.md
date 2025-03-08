# bzlmod

## 文档

> [https://bazel.build/versions/8.1.0/external/migration?hl=zh-cn](https://bazel.build/versions/8.1.0/external/migration?hl=zh-cn)

## 背景

由于 [WORKSPACE 的缺点](https://bazel.build/external/overview?hl=zh-cn#workspace-shortcomings)，Bzlmod 将取代旧版 WORKSPACE 系统。WORKSPACE 文件将在 Bazel 8（2024 年底）中默认停用，并在 Bazel 9（2025 年底）中移除。本指南可帮助您将项目迁移到 Bzlmod，并舍弃用于提取外部依赖项的 WORKSPACE。

## Workspace 与 Bzlmod

### 1. 定义 Bazel 工作区的根目录

WORKSPACE 文件用于标记 Bazel 项目的源代码根目录，在 Bazel 6.3 及更高版本中，此职责由 MODULE.bazel 取代。如果使用的是低于 6.3 的 Bazel 版本，您的工作区根目录中应该仍有 `WORKSPACE` 或 `WORKSPACE.bazel` 文件。

### 2. 在 bazelrc 中启用 Bzlmod

借助 `.bazelrc`，您可以设置每次运行 Bazel 时都会应用的标志。如需启用 Bzlmod，请使用 `--enable_bzlmod` 标志，并将其应用于 `common` 命令，以便将其应用于每个命令：

* `.bazelrc`

```bazel
# Enable Bzlmod for every Bazel command
common --enable_bzlmod
```

### 3. 为您的工作区指定代码库名称

* Workspace

workspace 函数用于为您的工作区指定代码库名称。这样，您就可以将工作区中的目标 `//foo:bar` 引用为 `@<workspace name>//foo:bar`。如果未指定，工作区的默认代码库名称为 `__main__`。

```bazel
## WORKSPACE
workspace(name = "com_foo_bar")
```

* Bzlmod

建议使用不带 `@<repo name>` 的 `//foo:bar` 语法引用同一工作区中的目标。不过，如果您确实需要旧语法，可以使用 module 函数指定的模块名称作为代码库名称。如果模块名称与所需的代码库名称不同，您可以使用 module 函数的 `repo_name` 属性替换代码库名称。

```bazel
## MODULE.bazel
module(
    name = "bar",
    repo_name = "com_foo_bar",
)
```

### 4. 将外部依赖项提取为 Bazel 模块

如果您的依赖项是 Bazel 项目，并且也采用了 Bzlmod，您应该能够将其作为 Bazel 模块进行依赖。

* Workspace

使用 WORKSPACE 时，通常使用 http_archive 或 git_repository 代码库规则下载 Bazel 项目的源代码。

```bazel
## WORKSPACE
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_skylib",
    urls = ["https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.2/bazel-skylib-1.4.2.tar.gz"],
    sha256 = "66ffd9315665bfaafc96b52278f57c7e2dd09f5ede279ea6d39b2be471e7e3aa",
)
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
bazel_skylib_workspace()

http_archive(
    name = "rules_java",
    urls = ["https://github.com/bazelbuild/rules_java/releases/download/6.1.1/rules_java-6.1.1.tar.gz"],
    sha256 = "76402a50ae6859d50bd7aed8c1b8ef09dae5c1035bb3ca7d276f7f3ce659818a",
)
load("@rules_java//java:repositories.bzl", "rules_java_dependencies", "rules_java_toolchains")
rules_java_dependencies()
rules_java_toolchains()
```

如您所见，用户需要从依赖项的宏中加载传递依赖项，这是一种常见的模式。假设 bazel_skylib 和 rules_java 都依赖于 platform，platform 依赖项的确切版本由宏的顺序决定。

* Bzlmod

使用 Bzlmod 时，只要您的依赖项在 Bazel 中央注册库或自定义 Bazel 注册库中可用，您只需使用 bazel_dep 指令即可依赖于它。

```bazel
## MODULE.bazel
bazel_dep(name = "bazel_skylib", version = "1.4.2")
bazel_dep(name = "rules_java", version = "6.1.1")
```

Bzlmod 使用 MVS 算法递进地解析 Bazel 模块依赖项。因此，系统会自动选择 platform 的最大所需版本。

### 5. 将依赖项替换为 Bazel 模块

作为根模块，您可以通过不同的方式替换 Bazel 模块依赖项。

如需了解详情，请参阅[替换项](https://bazel.build/versions/8.1.0/external/module?hl=zh-cn#overrides)部分。

您可以在[示例](https://github.com/bazelbuild/examples/blob/main/bzlmod/02-override_bazel_module)代码库中找到一些示例用法。

### 6. 使用模块扩展提取外部依赖项

如果您的依赖项不是 Bazel 项目，或者尚未在任何 Bazel 注册库中提供，您可以使用 [`use_repo_rule`](https://bazel.build/versions/8.1.0/external/module?hl=zh-cn#use_repo_rule) 或[模块扩展](https://bazel.build/external/extension?hl=zh-cn)引入它。

* Workspace

使用 [`http_file`](https://bazel.build/versions/8.1.0/rules/lib/repo/http?hl=zh-cn#http_file) 代码库规则下载文件。

```bazel
## WORKSPACE
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

http_file(
    name = "data_file",
    url = "http://example.com/file",
    sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
)
```

* Bzlmod

使用 Bzlmod 时，您可以在 MODULE.bazel 文件中使用 `use_repo_rule` 指令直接实例化代码库：

```
## MODULE.bazel
http_file = use_repo_rule("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
http_file(
    name = "data_file",
    url = "http://example.com/file",
    sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
)
```

在后台，这项功能是使用模块扩展实现的。如果您需要执行的逻辑比仅调用代码库规则更复杂，还可以自行实现模块扩展。您需要将该定义移至 `.bzl` 文件，这样您就可以在迁移期间在 WORKSPACE 和 Bzlmod 之间共享该定义。

```
## repositories.bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
def my_data_dependency():
    http_file(
        name = "data_file",
        url = "http://example.com/file",
        sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
    )
```

实现模块扩展以加载依赖项宏。您可以在宏的同一 `.bzl` 文件中定义它，但为了与较低版本的 Bazel 保持兼容性，最好在单独的 `.bzl` 文件中定义它。

```
## extensions.bzl
load("//:repositories.bzl", "my_data_dependency")
def _non_module_dependencies_impl(_ctx):
    my_data_dependency()

non_module_dependencies = module_extension(
    implementation = _non_module_dependencies_impl,
)
```

如需使代码库对根项目可见，您应在 MODULE.bazel 文件中声明模块扩展程序和代码库的用法。

```
## MODULE.bazel
non_module_dependencies = use_extension("//:extensions.bzl", "non_module_dependencies")
use_repo(non_module_dependencies, "data_file")
```

### 7. 使用模块扩展解决外部依赖项冲突

项目可以提供一个宏，该宏会根据调用方的输入引入外部代码库。但是，如果依赖项图中有多个调用方，并且它们之间存在冲突，该怎么办？

假设项目 `foo` 提供了以下宏，该宏将 `version` 作为参数。

```
## repositories.bzl in foo {:#repositories.bzl-foo}
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
def data_deps(version = "1.0"):
    http_file(
        name = "data_file",
        url = "http://example.com/file-%s" % version,
        # Omitting the "sha256" attribute for simplicity
    )
```

* Workspace

借助 WORKSPACE，您可以从 `@foo` 加载宏并指定所需数据依赖项的版本。假设您还有另一个依赖项 `@bar`，它也依赖于 `@foo`，但需要数据依赖项的其他版本。

```
## WORKSPACE

# Introduce @foo and @bar.
...

load("@foo//:repositories.bzl", "data_deps")
data_deps(version = "2.0")

load("@bar//:repositories.bzl", "bar_deps")
bar_deps() # -> which calls data_deps(version = "3.0")
```

在这种情况下，最终用户必须仔细调整 Workspace 中的宏顺序，才能获取所需的版本。这是 Workspace 的最大痛点之一，因为它实际上并未提供合理的方式来解析依赖项。

* Bzlmod

借助 Bzlmod，`foo` 项目的作者可以使用模块扩展来解决冲突。例如，假设始终从所有 Bazel 模块中选择数据依赖项的最大所需版本是合理的。

```
## extensions.bzl in foo
load("//:repositories.bzl", "data_deps")

data = tag_class(attrs={"version": attr.string()})

def _data_deps_extension_impl(module_ctx):
    # Select the maximal required version in the dependency graph.
    version = "1.0"
    for mod in module_ctx.modules:
        for data in mod.tags.data:
            version = max(version, data.version)
    data_deps(version)

data_deps_extension = module_extension(
    implementation = _data_deps_extension_impl,
    tag_classes = {"data": data},
)
```

```
## MODULE.bazel in bar
bazel_dep(name = "foo", version = "1.0")

foo_data_deps = use_extension("@foo//:extensions.bzl", "data_deps_extension")
foo_data_deps.data(version = "3.0")
use_repo(foo_data_deps, "data_file")
```

```
## MODULE.bazel in root module
bazel_dep(name = "foo", version = "1.0")
bazel_dep(name = "bar", version = "1.0")

foo_data_deps = use_extension("@foo//:extensions.bzl", "data_deps_extension")
foo_data_deps.data(version = "2.0")
use_repo(foo_data_deps, "data_file")
```

在本例中，根模块需要数据版本 `2.0`，而其依赖项 `bar` 需要 `3.0`。`foo` 中的模块扩展程序可以正确解决此冲突，并自动为数据依赖项选择版本 `3.0`。

### 8. 集成第三方软件包管理器

如上一节所述，由于模块扩展提供了一种从依赖项图中收集信息、执行自定义逻辑以解析依赖项以及调用仓库规则以引入外部仓库的方法，因此这为规则作者提供了一种增强集成特定语言的软件包管理器的规则集的绝佳方式。

请参阅[模块扩展](https://bazel.build/versions/8.1.0/external/extension?hl=zh-cn)页面，详细了解如何使用模块扩展。

下面列出了已采用 Bzlmod 从不同软件包管理器提取依赖项的规则集：

* [rules_jvm_external](https://github.com/bazelbuild/rules_jvm_external/blob/master/docs/bzlmod.md)
* [rules_go](https://github.com/bazelbuild/rules_go/blob/master/docs/go/core/bzlmod.md)
* [rules_python](https://github.com/bazelbuild/rules_python/blob/main/BZLMOD_SUPPORT.md)

[examples](https://github.com/bazelbuild/examples/tree/main/bzlmod/05-integrate_third_party_package_manager) 代码库提供了一个集成了伪软件包管理器的最小示例。

### 9. 检测主机上的工具链

当 Bazel 构建规则需要检测主机上可用的工具链时，它们会使用代码库规则检查主机，并将工具链信息生成为外部代码库。

* Workspace

给定以下代码库规则来检测 shell 工具链。

```
## local_config_sh.bzl
def _sh_config_rule_impl(repository_ctx):
    sh_path = get_sh_path_from_env("SH_BIN_PATH")

    if not sh_path:
        sh_path = detect_sh_from_path()

    if not sh_path:
        sh_path = "/shell/binary/not/found"

    repository_ctx.file("BUILD", """
load("@bazel_tools//tools/sh:sh_toolchain.bzl", "sh_toolchain")
sh_toolchain(
    name = "local_sh",
    path = "{sh_path}",
    visibility = ["//visibility:public"],
)
toolchain(
    name = "local_sh_toolchain",
    toolchain = ":local_sh",
    toolchain_type = "@bazel_tools//tools/sh:toolchain_type",
)
""".format(sh_path = sh_path))

sh_config_rule = repository_rule(
    environ = ["SH_BIN_PATH"],
    local = True,
    implementation = _sh_config_rule_impl,
)
```

您可以在 WORKSPACE 中加载代码库规则。

```
## WORKSPACE
load("//:local_config_sh.bzl", "sh_config_rule")
sh_config_rule(name = "local_config_sh")
```

* Bzlmod

使用 Bzlmod，您可以使用模块扩展引入相同的代码库，这类似于在上一节中引入 `@data_file` 代码库。

```
## local_config_sh_extension.bzl
load("//:local_config_sh.bzl", "sh_config_rule")

sh_config_extension = module_extension(
    implementation = lambda ctx: sh_config_rule(name = "local_config_sh"),
)
```

然后，在 MODULE.bazel 文件中使用该扩展。

```
## MODULE.bazel
sh_config_ext = use_extension("//:local_config_sh_extension.bzl", "sh_config_extension")
use_repo(sh_config_ext, "local_config_sh")
```

### 10. 注册工具链和执行平台

在上一小节中，我们介绍了托管工具链信息（例如 `local_config_sh`）的代码库，接下来，您可能需要注册工具链。

* Workspace

使用 WORKSPACE 时，您可以通过以下方式注册工具链。

1. 您可以在 `.bzl` 文件中注册工具链，并在 WORKSPACE 文件中加载宏。

```
## local_config_sh.bzl
def sh_configure():
    sh_config_rule(name = "local_config_sh")
    native.register_toolchains("@local_config_sh//:local_sh_toolchain")
```

```
## WORKSPACE
load("//:local_config_sh.bzl", "sh_configure")
sh_configure()
```

2. 或者直接在 WORKSPACE 文件中注册工具链。

```
## WORKSPACE
load("//:local_config_sh.bzl", "sh_config_rule")
sh_config_rule(name = "local_config_sh")
register_toolchains("@local_config_sh//:local_sh_toolchain")
```

* Bzlmod

使用 Bzlmod 时，[`register_toolchains`](https://bazel.build/versions/8.1.0/rules/lib/globals/module?hl=zh-cn#register_toolchains) 和 [`register_execution_platforms`](https://bazel.build/rules/lib/globals/module?hl=zh-cn#register_execution_platforms) API 仅在 MODULE.bazel 文件中可用。您无法在模块扩展程序中调用 `native.register_toolchains`。

```
## MODULE.bazel
sh_config_ext = use_extension("//:local_config_sh_extension.bzl", "sh_config_extension")
use_repo(sh_config_ext, "local_config_sh")
register_toolchains("@local_config_sh//:local_sh_toolchain")
```

在工具链选择期间，`WORKSPACE`、`WORKSPACE.bzlmod` 和每个 Bazel 模块的 `MODULE.bazel` 文件中注册的工具链和执行平台遵循以下优先级顺序（从高到低）：

1. 在根模块的 `MODULE.bazel` 文件中注册的工具链和执行平台。
2. 在 `WORKSPACE` 或 `WORKSPACE.bzlmod` 文件中注册的工具链和执行平台。
3. 由根模块的（传递）依赖项模块注册的工具链和执行平台。
4. 不使用 `WORKSPACE.bzlmod` 时：在 `WORKSPACE` [后缀](https://bazel.build/versions/8.1.0/external/migration?hl=zh-cn#builtin-default-deps)中注册的工具链。

### 11. 引入本地代码库

如果您需要依赖项的本地版本进行调试，或者想要将工作区中的某个目录作为外部代码库纳入，则可能需要将依赖项引入为本地代码库。

* Workspace

在 WORKSPACE 中，这通过两个原生代码库规则 [`local_repository`](https://bazel.build/versions/8.1.0/reference/be/workspace?hl=zh-cn#local_repository) 和 [`new_local_repository`](https://bazel.build/versions/8.1.0/reference/be/workspace?hl=zh-cn#new_local_repository) 实现。

```
## WORKSPACE
local_repository(
    name = "rules_java",
    path = "/Users/bazel_user/workspace/rules_java",
)
```

* Bzlmod

使用 Bzlmod 时，您可以使用 [`local_path_override`](https://bazel.build/versions/8.1.0/rules/lib/globals/module?hl=zh-cn#local_path_override) 使用本地路径替换模块。

```
## MODULE.bazel
bazel_dep(name = "rules_java")
local_path_override(
    module_name = "rules_java",
    path = "/Users/bazel_user/workspace/rules_java",
)
```

> **注意** ：使用 `local_path_override` 时，您只能将本地目录引入为 Bazel 模块，这意味着该目录应包含 MODULE.bazel 文件，并且在依赖项解析期间会考虑其传递依赖项。此外，所有模块替换指令只能由根模块使用。

您还可以引入具有模块扩展的本地代码库。不过，您无法在模块扩展中调用 `native.local_repository`，我们正在努力将所有原生代码库规则转换为 Starlark 规则（请查看 [#18285](https://github.com/bazelbuild/bazel/issues/18285) 了解进展）。然后，您可以在模块扩展程序中调用相应的 Starlark `local_repository`。如果这对您来说是一个阻碍问题，实现自定义版本的 `local_repository` 代码库规则也是小菜一碟。

### 12. 绑定目标

WORKSPACE 中的 [`bind`](https://bazel.build/versions/8.1.0/reference/be/workspace?hl=zh-cn#bind) 规则已废弃，Bzlmod 不支持该规则。它旨在为目标在特殊的 `//external` 软件包中提供别名。所有依赖于此 API 的用户都应进行迁移。

举例来说，如果你的：

```
## WORKSPACE
bind(
    name = "openssl",
    actual = "@my-ssl//src:openssl-lib",
)
```

这样，其他目标就可以依赖于 `//external:openssl`。您可以通过以下方式迁移：

* 将对 `//external:openssl` 的所有使用替换为 `@my-ssl//src:openssl-lib`。
* 或者使用 [`alias`](https://bazel.build/versions/8.1.0/reference/be/general?hl=zh-cn#alias) build 规则，在软件包（例如 `//third_party`）中定义以下目标，将对 `//external:openssl` 的所有使用替换为 `//third_party:openssl`。

```
## third_party/BUILD
alias(
    name = "openssl",
    actual = "@my-ssl//src:openssl-lib",
)
```

### 13. 	提取与同步

提取和同步命令用于在本地下载外部代码库并及时更新它们。有时，还允许在提取构建所需的所有代码库后，使用 `--nofetch` 标志离线构建。

* **Workspace**
  同步会针对所有代码库或一组特定配置的代码库强制提取，而提取*仅*用于针对特定目标提取。
* **Bzlmod**
  同步命令已不再适用，但提取功能提供了[各种选项](https://bazel.build/versions/8.1.0/reference/command-line-reference?hl=zh-cn#fetch-options)。您可以提取目标、代码库、一组已配置的代码库，或依赖项解析和模块扩展中涉及的所有代码库。提取结果会缓存，如需强制提取，您必须在提取过程中添加 `--force` 选项。
