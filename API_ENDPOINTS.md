# API endpoints

## Public
- `GET /health`
- `GET /health/db`
- `POST /api/auth/register`
- `POST /api/auth/login`

## Authenticated
- `GET /api/auth/me`
- `PUT /api/auth/me`
- `GET /api/records`
- `POST /api/records`
- `GET /api/records/{record_id}`
- `PUT /api/records/{record_id}`
- `DELETE /api/records/{record_id}`
- `POST /api/sync/batch`
- `GET /api/sync/history`
- `GET /api/sync/conflicts`
- `POST /api/sync/conflicts/{conflict_id}/resolve`
- `GET /api/dashboard/stats`

Swagger is available at `/docs`.
