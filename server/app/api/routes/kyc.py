from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlmodel import Session, select

from app.api.deps import get_session_dep, get_current_user_dep
from app.models import KYCProfile, User

router = APIRouter(prefix="/kyc", tags=["kyc"])


class KYCSubmit(BaseModel):
    doc_type: str
    doc_url: str
    selfie_url: str | None = None


class KYCStatus(BaseModel):
    status: str
    doc_type: str | None = None
    doc_url: str | None = None
    selfie_url: str | None = None


@router.post("/submit", response_model=KYCStatus, status_code=status.HTTP_201_CREATED)
async def submit_kyc(
    payload: KYCSubmit,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
):
    existing = session.exec(select(KYCProfile).where(KYCProfile.user_id == user.id)).first()
    if existing:
        existing.doc_type = payload.doc_type
        existing.doc_url = payload.doc_url
        existing.selfie_url = payload.selfie_url
        existing.status = "pending"
        existing.updated_at = datetime.utcnow()
        session.add(existing)
        session.commit()
        session.refresh(existing)
        profile = existing
    else:
        profile = KYCProfile(
            user_id=user.id,
            status="pending",
            doc_type=payload.doc_type,
            doc_url=payload.doc_url,
            selfie_url=payload.selfie_url,
        )
        session.add(profile)
        session.commit()
        session.refresh(profile)
    return KYCStatus(
        status=profile.status,
        doc_type=profile.doc_type,
        doc_url=profile.doc_url,
        selfie_url=profile.selfie_url,
    )


@router.get("/status", response_model=KYCStatus)
async def get_status(
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
):
    profile = session.exec(select(KYCProfile).where(KYCProfile.user_id == user.id)).first()
    if not profile:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="KYC not submitted")
    return KYCStatus(
        status=profile.status,
        doc_type=profile.doc_type,
        doc_url=profile.doc_url,
        selfie_url=profile.selfie_url,
    )
