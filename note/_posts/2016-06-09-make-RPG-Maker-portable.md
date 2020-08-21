---
title: 制作便携版 RPG Maker
---

由于 RPG Maker MV 的程序并没有管理员权限的需求，因此只要将 RPGMV 下的所有文件复制一份即可。
可以使用下面的脚本（cmd）设置关联。

```
@ECHO OFF

@SET HCUSC=HKEY_CURRENT_USER\Software\Classes

REG add "%HCUSC%\.rpgproject" /ve /t REG_SZ /d "RPGMV.Project" /f
REG add "%HCUSC%\RPGMV.Project" /ve /t REG_SZ /d "RPGMV Project" /f
REG add "%HCUSC%\RPGMV.Project\DefaultIcon" /ve /t REG_SZ /d "\"%~dp0RPGMV.exe\",1" /f
REG add "%HCUSC%\RPGMV.Project\shell\open\command" /ve /t REG_SZ /d "\"%~dp0RPGMV.exe\" \"%%1\"" /f
```

RPG Maker MZ 版：


```
@ECHO OFF

@SET HCUSC=HKEY_CURRENT_USER\Software\Classes

REG add "%HCUSC%\.rmmzproject" /ve /t REG_SZ /d "RPGMZ.Project" /f
REG add "%HCUSC%\RPGMZ.Project" /ve /t REG_SZ /d "RPGMZ Project" /f
REG add "%HCUSC%\RPGMZ.Project\DefaultIcon" /ve /t REG_SZ /d "\"%~dp0RPGMZ.exe\",1" /f
REG add "%HCUSC%\RPGMZ.Project\shell\open\command" /ve /t REG_SZ /d "\"%~dp0RPGMZ.exe\" \"%%1\"" /f
```

而 RPG Maker VX Ace 依赖于 rtp 的安装，所以需要管理员权限。

```
@ECHO OFF

SET "INSTALLDIR=%~dp0"
SET "INSTALLDIR=%INSTALLDIR:~0,-1%"
@SET HCUSC=HKEY_CURRENT_USER\Software\Classes

REG add "HKLM\SOFTWARE\enterbrain\rgss3\rtp" /v "rpgvxace" /t REG_SZ /d "%~dp0rtp" /f /reg:32
REG add "HKLM\SOFTWARE\enterbrain\rpgvxace" /v "applicationpath" /t REG_SZ /d "%INSTALLDIR%" /f /reg:32
REG add "%HCUSC%\.rvproj2" /ve /t REG_SZ /d "RPGVXAce.Project" /f
REG add "%HCUSC%\.rvdata2" /ve /t REG_SZ /d "RPGVXAce.Data" /f
REG add "%HCUSC%\.rgss3a" /ve /t REG_SZ /d "RPGVXAce.Archive" /f
REG add "%HCUSC%\rpgvxace.project" /ve /t REG_SZ /d "RPGVXAce Project" /f
REG add "%HCUSC%\rpgvxace.project\defaulticon" /ve /t REG_SZ /d "\"%~dp0RPGVXAce.exe\",1" /f
REG add "%HCUSC%\rpgvxace.project\shell\open\command" /ve /t REG_SZ /d "\"%~dp0RPGVXAce.exe\"  \"%%1\"" /f
REG add "%HCUSC%\rpgvxace.archive" /ve /t REG_SZ /d "RGSS Encrypted Archive" /f
REG add "%HCUSC%\rpgvxace.archive\defaulticon" /ve /t REG_SZ /d "\"%~dp0RPGVXAce.exe\",3" /f
REG add "%HCUSC%\rpgvxace.archive\shell\open\command" /ve /t REG_SZ /d "\"%~dp0RPGVXAce.exe\" /n \"%%1\"" /f
REG add "%HCUSC%\rpgvxace.data" /ve /t REG_SZ /d "RPGVXAce Data" /f
REG add "%HCUSC%\rpgvxace.data\defaulticon" /ve /t REG_SZ /d "\"%~dp0RPGVXAce.exe\",2" /f
REG add "%HCUSC%\rpgvxace.data\shell\open\command" /ve /t REG_SZ /d "\"%~dp0RPGVXAce.exe\" /n \"%%1\"" /f
```

RPG Maker VX 版：

```
@ECHO OFF

SET "INSTALLDIR=%~dp0"
SET "INSTALLDIR=%INSTALLDIR:~0,-1%"
@SET HCUSC=HKEY_CURRENT_USER\Software\Classes

REG add "HKLM\SOFTWARE\enterbrain\rgss2\rtp" /v "rpgvx" /t REG_SZ /d "%~dp0rtp" /f /reg:32
REG add "HKLM\SOFTWARE\enterbrain\rpgvx" /v "applicationpath" /t REG_SZ /d "%INSTALLDIR%" /f /reg:32
REG add "%HCUSC%\.rvproj" /ve /t REG_SZ /d "RPGVX.Project" /f
REG add "%HCUSC%\.rvdata" /ve /t REG_SZ /d "RPGVX.Data" /f
REG add "%HCUSC%\.rgss2a" /ve /t REG_SZ /d "RPGVX.Archive" /f
REG add "%HCUSC%\rpgvx.project" /ve /t REG_SZ /d "RPGVX Project" /f
REG add "%HCUSC%\rpgvx.project\defaulticon" /ve /t REG_SZ /d "\"%~dp0RPGVX.exe\",1" /f
REG add "%HCUSC%\rpgvx.project\shell\open\command" /ve /t REG_SZ /d "\"%~dp0RPGVX.exe\"  \"%%1\"" /f
REG add "%HCUSC%\rpgvx.archive" /ve /t REG_SZ /d "RGSS Encrypted Archive" /f
REG add "%HCUSC%\rpgvx.archive\defaulticon" /ve /t REG_SZ /d "\"%~dp0RPGVX.exe\",3" /f
REG add "%HCUSC%\rpgvx.archive\shell\open\command" /ve /t REG_SZ /d "\"%~dp0RPGVX.exe\" /n \"%%1\"" /f
REG add "%HCUSC%\rpgvx.data" /ve /t REG_SZ /d "RPGVX Data" /f
REG add "%HCUSC%\rpgvx.data\defaulticon" /ve /t REG_SZ /d "\"%~dp0RPGVX.exe\",2" /f
REG add "%HCUSC%\rpgvx.data\shell\open\command" /ve /t REG_SZ /d "\"%~dp0RPGVX.exe\" /n \"%%1\"" /f
```

RPG Maker XP 版：

```
@ECHO OFF

SET "INSTALLDIR=%~dp0"
SET "INSTALLDIR=%INSTALLDIR:~0,-1%"
@SET HCUSC=HKEY_CURRENT_USER\Software\Classes

REG add "HKLM\SOFTWARE\enterbrain\RGSS\RTP" /v "Standard" /t REG_SZ /d "%~dp0rtp" /f /reg:32
REG add "HKLM\SOFTWARE\enterbrain\RPGXP" /v "applicationpath" /t REG_SZ /d "%INSTALLDIR%" /f /reg:32
REG add "%HCUSC%\.rxproj" /ve /t REG_SZ /d "RPGXP.Project" /f
REG add "%HCUSC%\.rxdata" /ve /t REG_SZ /d "RPGXP.Data" /f
REG add "%HCUSC%\.rgssad" /ve /t REG_SZ /d "RPGXP.Archive" /f
REG add "%HCUSC%\RPGXP.Project" /ve /t REG_SZ /d "RPGXP Project" /f
REG add "%HCUSC%\RPGXP.Project\DefaultIcon" /ve /t REG_SZ /d "\"%~dp0RPGXP.exe\",1" /f
REG add "%HCUSC%\RPGXP.Project\shell\open\command" /ve /t REG_SZ /d "\"%~dp0RPGXP.exe\"  \"%%1\"" /f
REG add "%HCUSC%\RPGXP.Archive" /ve /t REG_SZ /d "RGSS Encrypted Archive" /f
REG add "%HCUSC%\RPGXP.Archive\DefaultIcon" /ve /t REG_SZ /d "\"%~dp0RPGXP.exe\",3" /f
REG add "%HCUSC%\RPGXP.Archive\shell\open\command" /ve /t REG_SZ /d "\"%~dp0RPGXP.exe\" /n \"%%1\"" /f
REG add "%HCUSC%\RPGXP.Data" /ve /t REG_SZ /d "RPGXP Data" /f
REG add "%HCUSC%\RPGXP.Data\DefaultIcon" /ve /t REG_SZ /d "\"%~dp0RPGXP.exe\",2" /f
REG add "%HCUSC%\RPGXP.Data\shell\open\command" /ve /t REG_SZ /d "\"%~dp0RPGXP.exe\" /n \"%%1\"" /f
```
