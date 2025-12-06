from fastapi import APIRouter

from app.api.routes import health, auth, users, trips, kyc, placeholders

api_router = APIRouter()
api_router.include_router(health.router)
api_router.include_router(auth.router)
api_router.include_router(users.router)
api_router.include_router(trips.router)
api_router.include_router(kyc.router)
api_router.include_router(placeholders.router)
