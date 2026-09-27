$ErrorActionPreference = "Stop"
Write-Host "Offline-First Sync System" -ForegroundColor Cyan
docker info | Out-Null
if ($LASTEXITCODE -ne 0) {
  Write-Host "Docker Engine is not available. Start Docker Desktop and run: docker run --rm hello-world" -ForegroundColor Red
  exit 1
}
if (!(Test-Path ".env")) {
  Copy-Item ".env.example" ".env"
  Write-Host "Created .env from .env.example" -ForegroundColor Yellow
}
docker compose build
docker compose up -d
docker compose ps
Write-Host "Frontend: http://localhost:5173" -ForegroundColor Green
Write-Host "Swagger:  http://localhost:8000/docs" -ForegroundColor Green
