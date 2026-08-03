@echo off
taskkill /F /IM dart.exe >nul 2>&1
timeout /t 2 /nobreak >nul
cd /d "C:\Users\K2R\Documents\Claude_Code\oasis_priere"
"C:\src\flutter\bin\flutter.bat" run -d chrome
pause
