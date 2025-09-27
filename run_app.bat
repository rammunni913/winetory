@echo off
echo Wine TorY Management System - Starting App...
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Flutter is not installed or not in PATH.
    echo Please run setup_flutter.bat first or install Flutter manually.
    echo.
    echo Download Flutter from: https://flutter.dev/docs/get-started/install/windows
    echo Add C:\flutter\bin to your PATH environment variable
    pause
    exit /b 1
)

echo Flutter found! Getting dependencies...
flutter pub get

if %errorlevel% neq 0 (
    echo Failed to get dependencies. Please check your internet connection.
    pause
    exit /b 1
)

echo.
echo Dependencies installed successfully!
echo.
echo Starting Wine TorY Management System...
echo.

REM Try to run on different platforms
echo Attempting to run on Windows...
flutter run -d windows

if %errorlevel% neq 0 (
    echo Windows run failed, trying Chrome...
    flutter run -d chrome
)

if %errorlevel% neq 0 (
    echo Chrome run failed, trying any available device...
    flutter run
)

echo.
echo App execution completed.
pause
