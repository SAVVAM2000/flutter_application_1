@echo off
rem Запуск локального тестового API для приложения (порт 8765).
cd /d "%~dp0..\.."
where dart >nul 2>nul
if %errorlevel%==0 (
    dart run tool\mock_api\server.dart
    goto :eof
)
if exist "C:\flutter\bin\dart.bat" (
    "C:\flutter\bin\dart.bat" run tool\mock_api\server.dart
    goto :eof
)
echo Не найден dart. Запустите вручную из папки проекта:
echo     dart run tool\mock_api\server.dart
pause
