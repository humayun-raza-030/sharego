# ShareGo Backend (FastAPI + SQLite)

This is the backend scaffold for ShareGo. Stack: FastAPI, SQLite (`sharego.db`), Jinja2 admin, optional MinIO for media.

## Quick start (planned)
- Create a `.env` from `.env.example`.
- Install dependencies (to be added) and run Alembic migrations.
- Start FastAPI (uvicorn) with reload during development.

## Configuration (env)
See `.env.example` for required values: PKR currency, Asia/Karachi timezone, JWT secret, OTP SMTP, media root, MinIO (optional).

## Media
- Default: local filesystem `./media` mounted at `/media`.
- MinIO: optional via env; not enabled by default.

## Persistence
- SQLite via SQLModel (`sharego.db`). On startup, tables auto-created for current models (no migrations yet).

## Tests
- For now, run with plugins disabled to avoid system-wide pytest plugins interfering:
  - `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python -m pytest -q`
  - `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python -m pytest --maxfail=1 -q`

Tests currently cover:
- Health endpoint
- Auth OTP request/verify (hashed + persisted OTP, user creation, JWT claims)

## Seed
- Run `python seed.py` to insert a demo user/trip if DB is empty.

## Warnings (to address later)
- FastAPI lifespan migration (on_event deprecation).
- httpx TestClient transport shortcut deprecation (switch to WSGITransport/ASGITransport when convenient).
