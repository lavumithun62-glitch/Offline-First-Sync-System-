@echo off
echo Starting backend in a new PowerShell window...
start "Offline Sync Backend" powershell -NoExit -ExecutionPolicy Bypass -File "%~dp0start-backend-local.ps1"
timeout /t 3 /nobreak >nul
echo Starting frontend in a new PowerShell window...
start "Offline Sync Frontend" powershell -NoExit -ExecutionPolicy Bypass -File "%~dp0start-frontend-local.ps1"
echo.
echo Backend:  http://localhost:8000
echo Swagger:  http://localhost:8000/docs
echo Frontend: http://localhost:5173
pause
