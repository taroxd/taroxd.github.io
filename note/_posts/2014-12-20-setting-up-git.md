---
title: "git 笔记"
---

新安装时的配置：

```shell
git config --global user.name taroxd
git config --global user.email taroxd@outlook.com
git config --global core.excludesfile ~/.gitignore
git config --global core.quotepath false
git config --global core.autocrlf input
# git config --global core.editor "subl --wait"
git config --global push.default simple
git config --global credential.helper wincred
git config --global credential.modalprompt false
# git config --global credential.helper store
# git config --global credential.helper 'cache --timeout 100000000'
git config --global pull.rebase true
# git config --global branch.autosetuprebase always
git config --global rebase.autoStash true
# git config --global commit.gpgsign true
# git config --global http.https://github.com.proxy socks5h://127.0.0.1:1080
```

彻底删除文件：

```shell
git filter-branch --force --index-filter "git rm -r --cached --ignore-unmatch path/to/your/file" --prune-empty --tag-name-filter cat -- --all
```
