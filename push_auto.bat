@echo off
REM Use the folder of this script as repo path
set "REPO_PATH=%~dp0"
if "%REPO_PATH:~-1%"=="\" set "REPO_PATH=%REPO_PATH:~0,-1%"

REM Commit message prefix
set "COMMIT_PREFIX=auto update"

cd /d "%REPO_PATH%"
echo Current repo directory: %cd%
echo.

REM Generate datetime string
set "DATETIME=%date%_%time%"
set "DATETIME=%DATETIME:/=-%"
set "DATETIME=%DATETIME: =_%"
set "DATETIME=%DATETIME::=-%"

set "COMMIT_MSG=%COMMIT_PREFIX% %DATETIME%"
echo Using commit message: %COMMIT_MSG%
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
    echo [INFO] No changes to commit or commit failed.
    goto done
)
echo.

echo ===== 4. git push =====
git push
echo.

:done
echo ***** DONE *****
pause