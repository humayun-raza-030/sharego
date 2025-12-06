from fastapi import APIRouter, Depends, HTTPException, status
from sqlmodel import Session, select

from app.api.deps import get_session_dep, get_current_user_dep
from app.models import Trip, User
from app.schemas import TripCreate, TripRead

router = APIRouter(prefix="/trips", tags=["trips"])


@router.post("", response_model=TripRead, status_code=status.HTTP_201_CREATED)
async def create_trip(
    payload: TripCreate,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
):
    trip = Trip(
        user_id=user.id,
        origin_airport=payload.origin_airport,
        dest_airport=payload.dest_airport,
        date=payload.date,
        capacity_kg=payload.capacity_kg,
        fee_pkr=payload.fee_pkr,
    )
    session.add(trip)
    session.commit()
    session.refresh(trip)
    return trip


@router.get("", response_model=list[TripRead])
async def list_trips(session: Session = Depends(get_session_dep)):
    trips = session.exec(select(Trip).order_by(Trip.date.desc())).all()
    return trips
