@echo off
echo Installing Flutter SDK for Wine TorY Management System...
echo.

REM Create Flutter directory
if not exist "C:\flutter" (
    echo Creating Flutter directory...
    mkdir C:\flutter
)

REM Download Flutter SDK
echo Downloading Flutter SDK...
powershell -Command "Invoke-WebRequest -Uri 'https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.9-stable.zip' -OutFile 'C:\flutter.zip'"

REM Extract Flutter
echo Extracting Flutter SDK...
powershell -Command "Expand-Archive -Path 'C:\flutter.zip' -DestinationPath 'C:\' -Force"

REM Add Flutter to PATH
echo Adding Flutter to PATH...
setx PATH "%PATH%;C:\flutter\bin" /M

REM Clean up
del C:\flutter.zip

echo.
echo Flutter installation complete!
echo Please restart your terminal and run:
echo   flutter doctor
echo   flutter pub get
echo   flutter run
echo.
pause
