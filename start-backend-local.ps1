$ErrorActionPreference = "Stop"
Set-Location "$PSScriptRoot\backend"

if (!(Test-Path ".venv")) {
    python -m venv .venv
}

& ".\.venv\Scripts\python.exe" -m pip install --upgrade pip
& ".\.venv\Scripts\python.exe" -m pip install -r requirements.txt

$env:DATABASE_URL = "sqlite:///./offline_sync.db"
$env:CORS_ORIGINS = "http://localhost:5173,http://localhost:3000"

& ".\.venv\Scripts\python.exe" -m alembic upgrade head
& ".\.venv\Scripts\python.exe" -m uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
