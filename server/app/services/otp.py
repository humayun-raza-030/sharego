from __future__ import annotations

from datetime import datetime, timedelta, timezone
import hashlib
import secrets

from sqlmodel import Session, select
from sqlalchemy import delete

from app.models import OTPEntry


class OTPService:
    """
    OTP persistence in SQLite (OTPEntry table).
    """

    @staticmethod
    def _hash(code: str) -> str:
        return hashlib.sha256(code.encode()).hexdigest()

    def issue(self, session: Session, email: str, ttl_seconds: int, max_attempts: int, dev_mode: bool = False) -> str:
        code = "123456" if dev_mode else f"{secrets.randbelow(900000) + 100000:06d}"
        hashed = self._hash(code)
        expires_at = datetime.now(timezone.utc) + timedelta(seconds=ttl_seconds)

        # upsert style: delete existing
        session.exec(delete(OTPEntry).where(OTPEntry.email == email))
        entry = OTPEntry(
            email=email,
            hashed_code=hashed,
            expires_at=expires_at,
            attempts=0,
            max_attempts=max_attempts,
        )
        session.add(entry)
        session.commit()
        return code

    def verify(self, session: Session, email: str, otp: str) -> bool:
        entry = session.exec(select(OTPEntry).where(OTPEntry.email == email)).first()
        if not entry:
            return False
        if entry.attempts >= entry.max_attempts:
            return False
        expires_at = entry.expires_at
        if expires_at.tzinfo is None:
            expires_at = expires_at.replace(tzinfo=timezone.utc)
        if expires_at < datetime.now(timezone.utc):
            return False
        entry.attempts += 1
        session.add(entry)
        session.commit()
        hashed = self._hash(otp)
        if hashed != entry.hashed_code:
            return False
        session.delete(entry)
        session.commit()
        return True


otp_service = OTPService()
