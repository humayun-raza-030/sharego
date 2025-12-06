import logging
import time
from pathlib import Path

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from starlette.staticfiles import StaticFiles

from app.api.routes import api_router
from app.core.config import get_settings
from admin_placeholder import router as admin_placeholder_router
from app.db import init_db


def create_application() -> FastAPI:
    """
    Minimal app factory for ShareGo backend.
    Routers for auth/users/trips/requests/bookings/escrow/listings/offers/messages/reviews/admin
    will be registered here in Sprint 1.
    """
    settings = get_settings()

    logging.basicConfig(
        level=logging.INFO if settings.env == "dev" else logging.WARNING,
        format="%(asctime)s %(levelname)s %(message)s",
    )

    app = FastAPI(title=settings.app_name, version="0.1.0")

    # CORS: allow local dev by default; tighten later per environment.
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"] if settings.env == "dev" else [],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Routers
    app.include_router(api_router)
    app.include_router(admin_placeholder_router)

    # Logging middleware
    @app.middleware("http")
    async def log_requests(request: Request, call_next):
        start = time.time()
        response = await call_next(request)
        duration_ms = (time.time() - start) * 1000
        logging.info(
            "path=%s method=%s status=%s duration_ms=%.2f",
            request.url.path,
            request.method,
            response.status_code,
            duration_ms,
        )
        return response

    # Ensure media root exists for local storage
    media_root = Path(settings.media_root)
    media_root.mkdir(parents=True, exist_ok=True)
    app.mount(settings.media_base_url, StaticFiles(directory=str(media_root)), name="media")

    # TODO: mount /static if needed, add Jinja2 admin.

    @app.on_event("startup")
    def on_startup():
        init_db()

    return app


app = create_application()
