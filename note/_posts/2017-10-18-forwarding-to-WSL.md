---
title: 建立 WSL 程序的快捷方式
---

安装 WSL 后，里面的 ssh 等程序本身就是一个非常好的 ssh 客户端。但是如果要从 cmd 环境运行的话，需要输入 `bash -c "ssh user@host"`，比较麻烦。把下面的 `ssh.cmd` 加入到 `PATH` 可以简化掉前面的 bash -c，变为 `ssh user@host` 以减少输入的长度。

**ssh.cmd**:
```
@SETLOCAL EnableDelayedExpansion
@SET args=%*
@SET args=!args:\=\\!
@SET args=!args:"=\"!
@bash -c "%~n0 %args%"
```

这段 cmd 脚本不只可以用来做 ssh 的快捷方式，也可以拿来做 scp 等程序的快捷方式（但使用绝对路径时需要用 `/mnt/c/path/to/file` 的形式）。使用该脚本可以方便地在 cmd 环境中调用 WSL 中的程序。

脚本只做了最简单的转义，但在日常中应该是足够使用了。

---

2017/11/01 追记：

Windows 10 秋季创意者更新版可以使用原生的 ssh 和 scp 了。美中不足的是不支持 rsa 密钥。

---

2018/06/14 追记：

Windows 10 1803 版本已经支持了 rsa 密钥。此外，`bash -c` 可以简单地替换为 `wsl`，转义之类的操作应该也不再需要了。
