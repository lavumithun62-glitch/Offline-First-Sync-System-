@echo off
echo Offline-First Sync System
docker info >nul 2>&1
if errorlevel 1 (
  echo Docker Engine is not available. Start Docker Desktop first.
  pause
  exit /b 1
)
if not exist .env copy .env.example .env
docker compose build
docker compose up -d
docker compose ps
pause
