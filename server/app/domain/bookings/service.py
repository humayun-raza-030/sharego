from __future__ import annotations

from datetime import datetime
from secrets import randbelow

from fastapi import HTTPException, status
from sqlmodel import Session, select

from app.core.audit import write_audit_log
from app.domain.escrow.service import deduct_wallet, get_balance, simulate_hold
from app.domain.handover.service import generate_codes
from app.models import Booking, BookingStatus, EscrowTx, HandoverEvent, RequestItem, Trip, User
from app.schemas.bookings import BookingCreate, BookingRead


def _utcnow() -> datetime:
    return datetime.utcnow()


def _waybill() -> str:
    return f"SG-{_utcnow():%y%m}-{randbelow(1_000_000):06d}"


def _get_booking_or_404(session: Session, booking_id: int) -> Booking:
    booking = session.get(Booking, booking_id)
    if not booking:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Booking not found")
    return booking


def _get_trip_request_or_404(session: Session, booking: Booking) -> tuple[Trip, RequestItem]:
    trip = session.get(Trip, booking.trip_id)
    if not trip:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Trip not found")
    request = session.get(RequestItem, booking.request_id)
    if not request:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Request not found")
    return trip, request


def _get_escrow(session: Session, booking_id: int) -> EscrowTx | None:
    return session.exec(
        select(EscrowTx)
        .where(EscrowTx.booking_id == booking_id)
        .order_by(EscrowTx.created_at.desc())
    ).first()


def _assert_transition(booking: Booking, allowed_from: set[str], target: BookingStatus) -> None:
    if booking.status not in allowed_from:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={
                "message": "Illegal booking transition",
                "from": booking.status,
                "to": target.value,
            },
        )


def _to_booking_read(
    session: Session,
    booking: Booking,
    *,
    pickup_code_dev: str | None = None,
    delivery_code_dev: str | None = None,
) -> BookingRead:
    trip, request = _get_trip_request_or_404(session, booking)
    escrow = _get_escrow(session, booking.id)
    events = session.exec(
        select(HandoverEvent).where(HandoverEvent.booking_id == booking.id)
    ).all()
    pickup_event = next((event for event in events if event.type == BookingStatus.PICKUP_OK.value), None)
    delivery_event = next((event for event in events if event.type == BookingStatus.DELIVERY_OK.value), None)
    buyer = session.get(User, request.user_id)
    buyer_name = (buyer.name or buyer.email) if buyer else None
    return BookingRead(
        id=booking.id,
        trip_id=booking.trip_id,
        request_id=booking.request_id,
        buyer_id=request.user_id,
        traveler_id=trip.user_id,
        status=booking.status,
        waybill=booking.waybill,
        escrow_status=escrow.status if escrow else None,
        amount=escrow.amount if escrow else None,
        currency=escrow.currency if escrow else None,
        seal_id=booking.seal_id,
        pickup_verified_at=pickup_event.ts if pickup_event else None,
        delivery_verified_at=delivery_event.ts if delivery_event else None,
        created_at=booking.created_at,
        updated_at=booking.updated_at,
        pickup_otp_dev=pickup_code_dev,
        delivery_otp_dev=delivery_code_dev,
        buyer_name=buyer_name,
        product_name=request.product_name,
    )


def create_booking(
    session: Session,
    *,
    buyer_id: int,
    data: BookingCreate,
    actor: str | None = None,
    request_id: str | None = None,
) -> BookingRead:
    trip = session.get(Trip, data.trip_id)
    if not trip:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Trip not found")
    if trip.user_id == buyer_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="You cannot book your own trip")
    request = session.get(RequestItem, data.request_id)
    if not request:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Request not found")
    if request.user_id != buyer_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="You can only book your own request")
    if request.weight_kg > trip.capacity_kg:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Request exceeds trip capacity")
    if trip.date < request.window_start or trip.date > request.window_end:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Trip date is outside request window")

    existing = session.exec(
        select(Booking).where(
            Booking.trip_id == data.trip_id,
            Booking.request_id == data.request_id,
            Booking.status.notin_([BookingStatus.CANCELLED.value, BookingStatus.EXPIRED.value]),
        )
    ).first()
    if existing:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Active booking already exists")

    # Check wallet balance before creating booking
    balance = get_balance(session, buyer_id)
    if balance < data.amount:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={
                "message": "Insufficient wallet balance",
                "balance": balance,
                "required": data.amount,
            },
        )

    booking = Booking(
        trip_id=data.trip_id,
        request_id=data.request_id,
        status=BookingStatus.REQUESTED.value,
        waybill=_waybill(),
        updated_at=_utcnow(),
    )
    session.add(booking)
    session.commit()
    session.refresh(booking)

    # Deduct from buyer wallet and place escrow hold
    deduct_wallet(
        session,
        user_id=buyer_id,
        amount=data.amount,
        reason="escrow_hold",
        ref_id=f"booking:{booking.id}",
    )
    simulate_hold(session, booking_id=booking.id, amount=data.amount, currency=data.currency)
    booking.status = BookingStatus.HOLD_PLACED.value
    booking.updated_at = _utcnow()
    session.add(booking)
    session.commit()
    session.refresh(booking)

    codes = generate_codes(session, booking_id=booking.id)
    write_audit_log(
        session,
        actor=actor or str(buyer_id),
        action="BOOKING_CREATED",
        entity=f"booking:{booking.id}",
        request_id=request_id,
        after={
            "status": booking.status,
            "trip_id": booking.trip_id,
            "request_id": booking.request_id,
            "amount": data.amount,
            "currency": data.currency,
        },
    )
    return _to_booking_read(
        session,
        booking,
        pickup_code_dev=codes["pickup_code"],
        delivery_code_dev=codes["delivery_code"],
    )


def get_booking(
    session: Session,
    *,
    booking_id: int,
    actor_id: int,
    is_admin: bool = False,
) -> BookingRead:
    booking = _get_booking_or_404(session, booking_id)
    trip, request = _get_trip_request_or_404(session, booking)
    if not is_admin and actor_id not in {trip.user_id, request.user_id}:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not allowed to view this booking")
    return _to_booking_read(session, booking)


def accept_booking(
    session: Session,
    *,
    booking_id: int,
    traveler_id: int,
    actor: str | None = None,
    request_id: str | None = None,
) -> BookingRead:
    booking = _get_booking_or_404(session, booking_id)
    trip, _request = _get_trip_request_or_404(session, booking)
    if trip.user_id != traveler_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only traveler can accept")
    _assert_transition(booking, {BookingStatus.HOLD_PLACED.value}, BookingStatus.ACCEPTED)

    booking.status = BookingStatus.ACCEPTED.value
    booking.updated_at = _utcnow()
    session.add(booking)
    session.commit()
    session.refresh(booking)
    write_audit_log(
        session,
        actor=actor or str(traveler_id),
        action="BOOKING_ACCEPTED",
        entity=f"booking:{booking.id}",
        request_id=request_id,
        after={"status": booking.status},
    )
    return _to_booking_read(session, booking)


def decline_booking(
    session: Session,
    *,
    booking_id: int,
    traveler_id: int,
    actor: str | None = None,
    request_id: str | None = None,
) -> BookingRead:
    booking = _get_booking_or_404(session, booking_id)
    trip, _request = _get_trip_request_or_404(session, booking)
    if trip.user_id != traveler_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only traveler can decline")
    _assert_transition(booking, {BookingStatus.HOLD_PLACED.value, BookingStatus.ACCEPTED.value}, BookingStatus.CANCELLED)

    booking.status = BookingStatus.CANCELLED.value
    booking.updated_at = _utcnow()
    session.add(booking)
    session.commit()
    session.refresh(booking)
    write_audit_log(
        session,
        actor=actor or str(traveler_id),
        action="BOOKING_DECLINED",
        entity=f"booking:{booking.id}",
        request_id=request_id,
        after={"status": booking.status},
    )
    return _to_booking_read(session, booking)


def cancel_booking(
    session: Session,
    *,
    booking_id: int,
    initiator_id: int,
    actor: str | None = None,
    request_id: str | None = None,
) -> BookingRead:
    booking = _get_booking_or_404(session, booking_id)
    _trip, request = _get_trip_request_or_404(session, booking)
    if request.user_id != initiator_id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Only booking initiator can cancel")
    _assert_transition(
        booking,
        {BookingStatus.REQUESTED.value, BookingStatus.HOLD_PLACED.value},
        BookingStatus.CANCELLED,
    )

    booking.status = BookingStatus.CANCELLED.value
    booking.updated_at = _utcnow()
    session.add(booking)
    session.commit()
    session.refresh(booking)
    write_audit_log(
        session,
        actor=actor or str(initiator_id),
        action="BOOKING_CANCELLED",
        entity=f"booking:{booking.id}",
        request_id=request_id,
        after={"status": booking.status},
    )
    return _to_booking_read(session, booking)


def expire_booking_manual(
    session: Session,
    *,
    booking_id: int,
    actor: str = "system",
    request_id: str | None = None,
) -> BookingRead:
    # Manual admin transition for single booking expiry.
    booking = _get_booking_or_404(session, booking_id)
    _assert_transition(
        booking,
        {BookingStatus.REQUESTED.value, BookingStatus.HOLD_PLACED.value},
        BookingStatus.EXPIRED,
    )

    booking.status = BookingStatus.EXPIRED.value
    booking.updated_at = _utcnow()
    session.add(booking)
    session.commit()
    session.refresh(booking)
    write_audit_log(
        session,
        actor=actor,
        action="BOOKING_EXPIRED",
        entity=f"booking:{booking.id}",
        request_id=request_id,
        after={"status": booking.status},
    )
    return _to_booking_read(session, booking)


def list_bookings_for_user(
    session: Session,
    *,
    actor_id: int,
    is_admin: bool = False,
    trip_id: int | None = None,
) -> list[BookingRead]:
    stmt = select(Booking).order_by(Booking.created_at.desc())
    if trip_id is not None:
        stmt = stmt.where(Booking.trip_id == trip_id)
    bookings = session.exec(stmt).all()
    output: list[BookingRead] = []
    for booking in bookings:
        trip, request = _get_trip_request_or_404(session, booking)
        if is_admin or actor_id in {trip.user_id, request.user_id}:
            output.append(_to_booking_read(session, booking))
    return output
