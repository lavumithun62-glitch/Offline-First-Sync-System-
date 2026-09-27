$ErrorActionPreference = "Stop"
Set-Location "$PSScriptRoot\frontend"

if (!(Test-Path "node_modules")) {
    npm install
}

$env:VITE_API_URL = "http://localhost:8000/api"
npm run dev
