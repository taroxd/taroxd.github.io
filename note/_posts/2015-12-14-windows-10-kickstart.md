---
title: Windows 10 相关 Cheatsheet
---

设置 Powershell Profile：

```powershell
# Load posh git
Import-Module 'D:\local\posh-git\src\posh-git.psd1'

# Customize git prompt
$s = $Global:GitPromptSettings
$s.BranchIdenticalStatusSymbol = $null
$s.BranchAheadStatusSymbol = $null
$s.BranchBehindStatusSymbol = $null
$s.BranchGoneStatusSymbol = $null
$s.BranchBehindAndAheadStatusSymbol = $null
$s.BranchBehindAndAheadDisplay = "Minimal"
$s.LocalWorkingStatusSymbol = $null
$s.LocalStagedStatusSymbol = $null
$s.WindowTitle = $null
$s.DefaultPromptAbbreviateHomeDirectory = False
```

设置网络属性为专用网络：

```powershell
Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceIndex <index number> -NetworkCategory Private
```

清理组件：

```
dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase
```
