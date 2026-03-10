@echo off
REM ################################################################################
REM Cadence Skills 离线安装脚本 (Windows)
REM
REM 使用方法:
REM   双击运行 install-offline.bat
REM   或在命令行中执行: install-offline.bat
REM
REM 作者: Cadence Team
REM 版本: v1.0
REM ################################################################################

setlocal enabledelayedexpansion

REM 打印横幅
echo ============================================================
echo   Cadence Skills 离线安装脚本 v1.0 (Windows)
echo ============================================================
echo.

REM 获取脚本所在目录（项目根目录）
set "SOURCE_DIR=%~dp0"
REM 去掉末尾的反斜杠
set "SOURCE_DIR=%SOURCE_DIR:~0,-1%"

REM 目标目录
set "TARGET_DIR=%USERPROFILE%\.claude\plugins\marketplaces\cadence-skills-local"
set "MARKETPLACES_DIR=%USERPROFILE%\.claude\plugins\marketplaces"

echo 📁 目标安装目录: %TARGET_DIR%
echo.

REM 步骤 1: 创建 marketplaces 目录
echo 🔨 步骤 1: 创建 marketplaces 目录
if not exist "%MARKETPLACES_DIR%" (
    mkdir "%MARKETPLACES_DIR%"
    echo   ✅ 已创建: %MARKETPLACES_DIR%
) else (
    echo   ℹ️  目录已存在: %MARKETPLACES_DIR%
)
echo.

REM 步骤 2: 创建 cadence-skills-local 目录
echo 🔨 步骤 2: 创建 cadence-skills-local 目录
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
    echo   ✅ 已创建: %TARGET_DIR%
) else (
    echo   ℹ️  目录已存在: %TARGET_DIR%
    echo   ⚠️  将覆盖现有安装
)
echo.

REM 步骤 3: 复制项目文件
echo 🔨 步骤 3: 复制项目文件
echo   📂 源目录: %SOURCE_DIR%
echo   📂 目标目录: %TARGET_DIR%
echo.

REM 删除目标目录中的所有内容（准备覆盖）
if exist "%TARGET_DIR%" (
    echo   🗑️  清理旧文件...
    del /q "%TARGET_DIR%\*" 2>nul
    for /d %%p in ("%TARGET_DIR%\*") do rd /s /q "%%p" 2>nul
)

REM 复制所有文件（排除 .git 目录）
echo   📋 复制文件中...
xcopy "%SOURCE_DIR%" "%TARGET_DIR%\" /E /I /Y /EXCLUDE:exclude.txt >nul 2>&1

REM 如果 exclude.txt 不存在，使用备用方法
if errorlevel 1 (
    REM 复制所有文件
    xcopy "%SOURCE_DIR%" "%TARGET_DIR%\" /E /I /Y >nul

    REM 删除 .git 目录
    if exist "%TARGET_DIR%\.git" (
        rd /s /q "%TARGET_DIR%\.git"
    )
)

echo.
echo   ✅ 复制完成
echo.

REM 步骤 4: 配置 known_marketplaces.json
echo 🔨 步骤 4: 配置 known_marketplaces.json

set "PLUGINS_DIR=%USERPROFILE%\.claude\plugins"
set "MARKETPLACES_FILE=%PLUGINS_DIR%\known_marketplaces.json"

REM 创建 plugins 目录（如果不存在）
if not exist "%PLUGINS_DIR%" (
    mkdir "%PLUGINS_DIR%"
    echo   ✅ 已创建: %PLUGINS_DIR%
)

REM 获取当前时间戳（UTC格式）
for /f "usebackq" %%i in (`powershell -Command "Get-Date -Format 'yyyy-MM-ddTHH:mm:ss.000Z' -AsUTC"`) do set CURRENT_TIMESTAMP=%%i

REM 检查文件是否存在
if not exist "%MARKETPLACES_FILE%" (
    REM 文件不存在，创建新文件
    echo   ℹ️  文件不存在，创建新文件

    REM 使用 PowerShell 创建 JSON 文件
    powershell -Command ^
        "$json = @{ ^
            'cadence-skills-local' = @{ ^
                'source' = @{ ^
                    'source' = 'github'; ^
                    'repo' = 'cadence/cadence-skills-local' ^
                }; ^
                'installLocation' = '%TARGET_DIR:\=\\%'; ^
                'lastUpdated' = '%CURRENT_TIMESTAMP%' ^
            } ^
        } | ConvertTo-Json -Depth 10; ^
        $json | Out-File -FilePath '%MARKETPLACES_FILE%' -Encoding UTF8"

    echo   ✅ 已创建配置文件
) else (
    REM 文件存在，追加或更新 superpowers-marketplace 配置
    echo   ℹ️  文件已存在，检查配置

    REM 使用 PowerShell 检查和更新 JSON
    powershell -Command ^
        "$file = '%MARKETPLACES_FILE%'; ^
         $json = Get-Content $file -Raw | ConvertFrom-Json; ^
         ^
         if ($json.PSObject.Properties.Match('superpowers-marketplace')) { ^
             Write-Host '  ℹ️  superpowers-marketplace 配置已存在'; ^
         } else { ^
             Write-Host '  ℹ️  添加 superpowers-marketplace 配置'; ^
             $
             Add-Member -InputObject $json -MemberType NoteProperty -Name 'superpowers-marketplace' -Value @{ ^
                 source = @{ ^
                     source = 'github'; ^
                     repo = 'obra/superpowers-marketplace' ^
                 }; ^
                 installLocation = '%USERPROFILE:\=\\%\.claude\plugins\marketplaces\superpowers-marketplace'; ^
                 lastUpdated = '%CURRENT_TIMESTAMP%' ^
             }; ^
             $
             $json | ConvertTo-Json -Depth 10 | Out-File -FilePath $file -Encoding UTF8; ^
             Write-Host '  ✅ 已添加 superpowers-marketplace 配置'; ^
         }"
)

echo.

REM 安装完成
echo ============================================================
echo   ✅ 安装成功！
echo ============================================================
echo.
echo 📍 安装位置: %TARGET_DIR%
echo.
echo 💡 提示:
echo   - 重启 Claude Code 以加载新安装的 skills
echo   - 使用 /cadence:* 命令访问 Cadence skills
echo.

pause
