@echo off
echo Searching for Flutter installation...
echo.

REM Check common Flutter locations
set FLUTTER_PATHS=C:\flutter\bin\flutter.exe C:\Users\%USERNAME%\flutter\bin\flutter.exe C:\Users\%USERNAME%\AppData\Local\flutter\bin\flutter.exe C:\Program Files\flutter\bin\flutter.exe

for %%p in (%FLUTTER_PATHS%) do (
    if exist "%%p" (
        echo Found Flutter at: %%p
        echo.
        echo Testing Flutter...
        "%%p" --version
        if !errorlevel! equ 0 (
            echo.
            echo ✅ Flutter is working! Building APK...
            echo.
            "%%p" clean
            "%%p" pub get
            "%%p" build apk --release
            if !errorlevel! equ 0 (
                echo.
                echo ✅ APK built successfully!
                echo APK location: build\app\outputs\flutter-apk\app-release.apk
            ) else (
                echo ❌ APK build failed.
            )
            goto :end
        )
    )
)

echo Flutter not found in common locations.
echo.
echo Please install Flutter manually:
echo 1. Download from: https://flutter.dev/docs/get-started/install/windows
echo 2. Extract to: C:\flutter
echo 3. Add C:\flutter\bin to PATH
echo 4. Restart terminal
echo.
echo Then run: build_apk.bat

:end
pause
