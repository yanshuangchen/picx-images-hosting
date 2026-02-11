@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Use the folder of this script as repo path
set "REPO_PATH=%~dp0"
if "%REPO_PATH:~-1%"=="\" set "REPO_PATH=%REPO_PATH:~0,-1%"

REM Commit message prefix
set "COMMIT_PREFIX=auto update"

cd /d "%REPO_PATH%"
echo Current repo directory: %cd%
echo.

REM Ensure we're in a git repo
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Not a git repository.
    goto done
)

REM Generate datetime string
set "DATETIME=%date%_%time%"
set "DATETIME=%DATETIME:/=-%"
set "DATETIME=%DATETIME: =_%"
set "DATETIME=%DATETIME::=-%"

set "COMMIT_MSG=%COMMIT_PREFIX% %DATETIME%"
echo Using commit message: %COMMIT_MSG%
echo.

echo ===== 1. git add -A =====
git add -A
echo.

echo ===== 2. git commit (if changes) =====
git diff --cached --quiet
if errorlevel 1 (
    git commit -m "%COMMIT_MSG%"
) else (
    echo [INFO] No changes to commit.
)
echo.

echo ===== 3. git pull --rebase (auto-stash) =====
git pull --rebase --autostash
if errorlevel 1 (
    echo [ERROR] git pull --rebase failed. Resolve conflicts and retry.
    goto done
)
echo.

echo ===== 4. git push =====
git push
if errorlevel 1 (
    echo [ERROR] git push failed.
    goto done
)
echo.

:done
echo ***** DONE *****
pause
