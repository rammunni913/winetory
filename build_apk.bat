@echo off
echo Building Wine TorY Management System APK...
echo.

REM Check if Flutter is available
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Flutter is not installed or not in PATH.
    echo.
    echo Please install Flutter first:
    echo 1. Download from: https://flutter.dev/docs/get-started/install/windows
    echo 2. Extract to: C:\flutter
    echo 3. Add C:\flutter\bin to your PATH
    echo 4. Restart terminal
    echo.
    pause
    exit /b 1
)

echo Flutter found! Building APK...
echo.

REM Clean previous builds
echo Cleaning previous builds...
flutter clean

REM Get dependencies
echo Getting dependencies...
flutter pub get

if %errorlevel% neq 0 (
    echo Failed to get dependencies.
    pause
    exit /b 1
)

REM Build APK
echo Building release APK...
flutter build apk --release

if %errorlevel% neq 0 (
    echo APK build failed.
    pause
    exit /b 1
)

echo.
echo ✅ APK built successfully!
echo.
echo APK location: build\app\outputs\flutter-apk\app-release.apk
echo.
echo You can now install this APK on your Android device.
echo.
pause
