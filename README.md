# Offline-First Sync System — NO DOCKER Emergency Run Mode

## IMPORTANT
This copy is specifically for continuing development when Docker Desktop is not working.
**Docker is NOT required to run this version.**

For local development it uses:
- FastAPI + SQLAlchemy
- SQLite (`backend/offline_sync.db`) instead of MySQL
- React + Vite + TypeScript + Material UI
- IndexedDB for offline client data
- JWT authentication
- The same synchronization/conflict/history/dashboard features from the original package

MySQL 8 + Redis + Docker Compose remain in the original package for deployment/integration testing.

## Start with one command

From PowerShell in this folder:

```powershell
.\start-local.bat
```

Or start separately:

### Backend
```powershell
.\start-backend-local.ps1
```

Backend:
- http://localhost:8000
- Swagger: http://localhost:8000/docs

### Frontend
Open a second PowerShell:
```powershell
.\start-frontend-local.ps1
```

Frontend:
- http://localhost:5173

## First login
Register a user from the application first. Then create records and test offline mode by disabling the browser network/connection. When the connection returns, the IndexedDB queue automatically attempts synchronization.

## Why this copy exists
Your Docker Desktop engine is currently not responding to `docker run --rm hello-world`; therefore repeatedly rebuilding the application cannot make progress. This package lets you continue with the application features immediately without spending more time on Docker.

# Offline-First Data Synchronization System

A full-stack offline-first CRUD and synchronization platform built to the requested specification.

## Stack

- Backend: Python 3.12, FastAPI, SQLAlchemy 2, Alembic, Pydantic v2, JWT, Redis
- Frontend: React + Vite + TypeScript, Material UI, Axios, React Router, IndexedDB
- Database: MySQL 8
- Infrastructure: Docker Compose
- Tests: pytest
- API documentation: Swagger/OpenAPI
- API client: Postman collection

## Features

- Registration/login/JWT authentication
- User profile and role-based access
- Online CRUD and offline CRUD
- IndexedDB local record store
- IndexedDB pending operation queue
- Automatic online/offline detection
- Automatic synchronization after reconnect
- Idempotent client operation IDs
- Optimistic concurrency using record versions
- Conflict detection
- Configurable conflict strategy: `server_wins`, `client_wins`, `last_write_wins`
- Conflict list and resolution endpoints
- Synchronization history
- Audit logs
- Dashboard statistics
- Search, status/date/conflict filters, pagination and sorting
- Redis coordination/short-lived dashboard cache
- Transactional sync processing
- Retry-safe synchronization
- Unit tests for synchronization/conflict logic
- Docker Compose for MySQL, Redis, backend and frontend

## Project layout

```text
offline-first-sync-system/
├── backend/
│   ├── app/
│   ├── alembic/
│   ├── tests/
│   ├── Dockerfile
│   ├── requirements.txt
│   └── alembic.ini
├── frontend/
│   ├── src/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── package.json
├── postman/
│   └── Offline-First-Sync.postman_collection.json
├── docker-compose.yml
├── .env.example
├── .dockerignore
├── start.ps1
├── start.bat
└── README.md
```

## Docker startup

### Windows PowerShell

Make sure Docker Desktop is running and the terminal prompt is PowerShell, for example:

```text
PS C:\...\offline-first-sync-system>
```

Do NOT run Docker CLI from the internal `docker-desktop` WSL distribution.

Copy environment file:

```powershell
Copy-Item .env.example .env
```

Build and start:

```powershell
docker compose build
docker compose up -d
```

Check:

```powershell
docker compose ps
```

Logs:

```powershell
docker compose logs -f backend
```

URLs:

- Frontend: http://localhost:5173
- API: http://localhost:8000
- Swagger: http://localhost:8000/docs
- Health: http://localhost:8000/health

Stop:

```powershell
docker compose down
```

Reset database volume (destructive):

```powershell
docker compose down -v
```

### If Docker Engine is not responding

The project cannot repair a stopped Docker Desktop engine. Start/restart Docker Desktop first and verify:

```powershell
docker info
docker run --rm hello-world
```

Only after `hello-world` works should you run Compose.

If `wsl -l -v` shows `docker-desktop` as stopped immediately after Docker Desktop starts, restart Docker Desktop. Do not enter `wsl -d docker-desktop` to run Compose.

## Non-Docker backend setup

Python 3.12 is recommended.

```powershell
cd backend
py -3.12 -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

Set `.env` from the root example and make sure MySQL/Redis are running.

Then:

```powershell
alembic upgrade head
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

## Non-Docker frontend setup

```powershell
cd frontend
npm install
npm run dev
```

## Default demo account

The backend does not hard-code a production password. Register a user from the UI or:

`POST /api/auth/register`

Example:

```json
{
  "email": "demo@example.com",
  "password": "Demo@12345",
  "full_name": "Demo User"
}
```

## Synchronization model

Every local mutation creates a globally unique `operation_id`.

Each record has a monotonically increasing `version`.

The client sends:

- operation ID
- record ID
- operation type
- payload
- client timestamp
- base server version

The backend:

1. Checks whether the operation ID was already processed.
2. Locks the record transactionally.
3. Compares the supplied base version with the server version.
4. Applies the configured conflict strategy.
5. Writes sync history and audit log.
6. Returns the resulting record/conflict state.

This makes retries safe and prevents the same operation from being applied twice.

## Conflict strategies

Configured with `CONFLICT_STRATEGY`:

- `server_wins`: keep server data and create a conflict entry.
- `client_wins`: apply the client mutation despite a version mismatch.
- `last_write_wins`: compare timestamps and apply the newer mutation; ties favor the server.

The UI exposes conflict records and allows explicit server/client resolution.

## Tests

From `backend`:

```powershell
pytest -q
```

The tests include version conflicts, idempotency, server-wins, client-wins and last-write-wins decision logic.

## Security

- Passwords are hashed with Argon2.
- JWT secret is loaded from environment variables.
- Database credentials are loaded from environment variables.
- CORS origins are configurable.
- API mutations require JWT.
- Admin-only endpoints are protected.

## Notes

This repository is designed to be a complete reference implementation. For production deployment, add HTTPS, a production-grade secret, external object storage if needed, monitoring, backups and a managed database.
