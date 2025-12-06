from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, EmailStr
from sqlmodel import Session, select

from app.api.deps import get_settings_dep, get_session_dep
from app.core.config import Settings
from app.core.security import create_access_token
from app.models import User
from app.services.otp import otp_service

router = APIRouter(prefix="/auth", tags=["auth"])


class OTPRequest(BaseModel):
    email: EmailStr
    phone: str | None = None


class OTPVerify(BaseModel):
    email: EmailStr
    otp: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    roles: list[str] = ["user"]
    expires_in_minutes: int


@router.post("/register", response_model=dict)
async def request_otp(
    payload: OTPRequest,
    settings: Settings = Depends(get_settings_dep),
    session: Session = Depends(get_session_dep),
):
    code = otp_service.issue(
        session=session,
        email=payload.email,
        ttl_seconds=settings.otp_ttl_seconds,
        max_attempts=settings.otp_max_attempts,
        dev_mode=settings.env == "dev",
    )
    # ensure user exists with role user
    user = session.exec(select(User).where(User.email == payload.email)).first()
    if not user:
        session.add(User(email=payload.email, phone=payload.phone or "", roles_csv="user"))
        session.commit()
    response = {"message": "OTP issued"}
    if settings.env == "dev":
        response["otp_dev"] = code
    return response


@router.post("/verify-otp", response_model=TokenResponse)
async def verify_otp(
    payload: OTPVerify,
    settings: Settings = Depends(get_settings_dep),
    session: Session = Depends(get_session_dep),
):
    valid = otp_service.verify(session=session, email=payload.email, otp=payload.otp)
    if not valid:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid OTP")
    user = session.exec(select(User).where(User.email == payload.email)).first()
    roles = user.roles if user else ["user"]
    token = create_access_token(
        subject=payload.email,
        settings=settings,
        extra_claims={"roles": roles},
    )
    return TokenResponse(access_token=token, roles=roles, expires_in_minutes=settings.jwt_expire_minutes)
