@echo off
title AarogyaSathi — Starting...
echo.
echo  ╔══════════════════════════════════════════╗
echo  ║        AarogyaSathi AI Health App        ║
echo  ║   Offline Rural Health Assistant — India ║
echo  ╚══════════════════════════════════════════╝
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo  [ERROR] Python is not installed or not in PATH.
    echo.
    echo  Please install Python from https://www.python.org/downloads/
    echo  Make sure to check "Add Python to PATH" during installation.
    echo.
    pause
    exit /b 1
)

echo  [OK] Python found. Starting server...
echo.
echo  ┌─────────────────────────────────────────┐
echo  │  App is running at:                     │
echo  │                                         │
echo  │      http://localhost:3000              │
echo  │                                         │
echo  │  Opening in your browser...             │
echo  │  Press Ctrl+C in this window to stop.   │
echo  └─────────────────────────────────────────┘
echo.

REM Open browser after short delay
start /b cmd /c "timeout /t 2 /nobreak >nul && start http://localhost:3000"

REM Serve the web build
python -m http.server 3000 --directory build\web
