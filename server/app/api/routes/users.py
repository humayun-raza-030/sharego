from fastapi import APIRouter, Depends, HTTPException, status
from sqlmodel import Session, select

from app.api.deps import get_session_dep
from app.models import User
from app.schemas import UserRead

router = APIRouter(prefix="/users", tags=["users"])


@router.get("/{user_id}", response_model=UserRead)
async def get_user(user_id: int, session: Session = Depends(get_session_dep)):
    user = session.exec(select(User).where(User.id == user_id)).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return UserRead(
        id=user.id,
        email=user.email,
        phone=user.phone,
        roles=user.roles,
        created_at=user.created_at,
    )


@router.get("/me", response_model=UserRead)
async def get_me(session: Session = Depends(get_session_dep)):
    # TODO: replace with real auth; for now return first user if exists
    user = session.exec(select(User)).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    return UserRead(
        id=user.id,
        email=user.email,
        phone=user.phone,
        roles=user.roles,
        created_at=user.created_at,
    )
