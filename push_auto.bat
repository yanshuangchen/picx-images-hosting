@echo off
REM 使用当前脚本所在目录作为仓库路径
set "REPO_PATH=%~dp0"
if "%REPO_PATH:~-1%"=="\" set "REPO_PATH=%REPO_PATH:~0,-1%"

REM 提交前缀
set "COMMIT_PREFIX=auto update"

cd /d "%REPO_PATH%"
echo 当前仓库目录：%cd%
echo.

REM 生成日期时间
set "DATETIME=%date%_%time%"
set "DATETIME=%DATETIME:/=-%"
set "DATETIME=%DATETIME: =_%"
set "DATETIME=%DATETIME::=-%"

set "COMMIT_MSG=%COMMIT_PREFIX% %DATETIME%"
echo 使用提交说明：%COMMIT_MSG%
echo.

echo ===== 1. git pull =====
git pull
echo.

echo ===== 2. git add . =====
git add .
echo.

echo ===== 3. git commit =====
git commit -m "%COMMIT_MSG%"
if errorlevel 1 (
    echo [提示] 可能没有文件变更或 commit 失败（比如没有改动）。
    goto done
)
echo.

echo ===== 4. git push =====
git push
echo.

:done
echo ***** 完成 *****
pause