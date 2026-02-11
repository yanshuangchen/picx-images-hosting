@echo off
setlocal EnableExtensions

set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"

powershell -NoProfile -ExecutionPolicy Bypass -Command "& { $root = '%ROOT%'; $temp = Join-Path $root 'temp'; $ext = @('.jpg','.jpeg','.png','.gif','.bmp','.webp','.tif','.tiff','.heic','.heif','.ico','.svg'); New-Item -ItemType Directory -Force -Path $temp | Out-Null; $files = Get-ChildItem -Path $root -File | Where-Object { $ext -contains $_.Extension.ToLower() }; foreach ($f in $files) { $dest = Join-Path $temp $f.Name; if (Test-Path -LiteralPath $dest) { $base = [IO.Path]::GetFileNameWithoutExtension($f.Name); $extn = $f.Extension; $i = 1; do { $dest = Join-Path $temp ('{0}_{1}{2}' -f $base, $i, $extn); $i++ } while (Test-Path -LiteralPath $dest) }; Move-Item -LiteralPath $f.FullName -Destination $dest }; Write-Host ('Moved {0} file(s) to {1}' -f $files.Count, $temp) }"
echo.
pause
