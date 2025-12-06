from datetime import datetime
from typing import Optional

from pydantic import BaseModel, EmailStr, Field


class UserRead(BaseModel):
    id: int
    email: EmailStr
    phone: Optional[str] = None
    roles: list[str]
    created_at: datetime


class TripCreate(BaseModel):
    origin_airport: str = Field(min_length=3, max_length=5)
    dest_airport: str = Field(min_length=3, max_length=5)
    date: datetime
    capacity_kg: float = Field(gt=0)
    fee_pkr: Optional[int] = Field(default=None, ge=0)


class TripRead(BaseModel):
    id: int
    user_id: int
    origin_airport: str
    dest_airport: str
    date: datetime
    capacity_kg: float
    fee_pkr: Optional[int]
    created_at: datetime
