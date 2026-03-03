from __future__ import annotations

from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlmodel import Session, col, func, or_, select

from app.api.deps import get_current_user_dep, get_session_dep
from app.models import Message, User
from app.schemas.messages import MessageCreate, MessageRead, ThreadSummary

router = APIRouter(prefix="/messages", tags=["messages"])


@router.post("", response_model=MessageRead, status_code=status.HTTP_201_CREATED)
async def send_message(
    payload: MessageCreate,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
):
    if payload.receiver_id == user.id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Cannot message yourself")
    receiver = session.get(User, payload.receiver_id)
    if not receiver:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Receiver not found")
    msg = Message(
        sender_id=user.id,
        receiver_id=payload.receiver_id,
        content=payload.content,
        booking_id=payload.booking_id,
        listing_id=payload.listing_id,
    )
    session.add(msg)
    session.commit()
    session.refresh(msg)
    return msg


@router.get("", response_model=list[MessageRead])
async def list_messages(
    peer_id: int = Query(..., description="ID of the other user in the conversation"),
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
):
    msgs = session.exec(
        select(Message)
        .where(
            or_(
                (Message.sender_id == user.id) & (Message.receiver_id == peer_id),
                (Message.sender_id == peer_id) & (Message.receiver_id == user.id),
            )
        )
        .order_by(col(Message.created_at).asc())
    ).all()

    # Mark unread messages from peer as read.
    now = datetime.utcnow()
    for m in msgs:
        if m.receiver_id == user.id and m.read_at is None:
            m.read_at = now
            session.add(m)
    session.commit()

    return msgs


@router.get("/threads", response_model=list[ThreadSummary])
async def list_threads(
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
):
    all_msgs = session.exec(
        select(Message)
        .where(or_(Message.sender_id == user.id, Message.receiver_id == user.id))
        .order_by(col(Message.created_at).desc())
    ).all()

    threads: dict[int, ThreadSummary] = {}
    for m in all_msgs:
        peer = m.receiver_id if m.sender_id == user.id else m.sender_id
        if peer not in threads:
            unread = sum(
                1 for msg in all_msgs
                if msg.sender_id == peer and msg.receiver_id == user.id and msg.read_at is None
            )
            threads[peer] = ThreadSummary(
                peer_id=peer,
                last_message=m.content,
                last_ts=m.created_at,
                unread_count=unread,
            )

    return sorted(threads.values(), key=lambda t: t.last_ts, reverse=True)
