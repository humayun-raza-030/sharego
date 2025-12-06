from __future__ import annotations

from datetime import datetime
from typing import Optional

from sqlmodel import SQLModel, Field


class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    email: str = Field(index=True, unique=True)
    phone: Optional[str] = None
    roles_csv: str = Field(default="user")  # comma-separated roles
    created_at: datetime = Field(default_factory=datetime.utcnow)

    @property
    def roles(self) -> list[str]:
        return [r for r in self.roles_csv.split(",") if r]


class OTPEntry(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    email: str = Field(index=True)
    hashed_code: str
    expires_at: datetime
    attempts: int = 0
    max_attempts: int = 3
    created_at: datetime = Field(default_factory=datetime.utcnow)


class Trip(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(index=True)
    origin_airport: str = Field(index=True)
    dest_airport: str = Field(index=True)
    date: datetime
    capacity_kg: float
    fee_pkr: int | None = None
    created_at: datetime = Field(default_factory=datetime.utcnow)


class KYCProfile(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(index=True)
    status: str = Field(default="pending")  # pending/approved/rejected
    doc_type: str | None = None
    doc_url: str | None = None
    selfie_url: str | None = None
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
