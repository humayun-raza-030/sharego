from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from sqlmodel import Session, col, select

from app.api.deps import get_current_user_dep, get_request_id_dep, get_session_dep, get_settings_dep, enforce_kyc_approved
from app.core.config import Settings
from app.core.limits import limiter
from app.domain.marketplace.service import (
    accept_offer,
    confirm_meetup,
    counter_offer,
    create_listing,
    create_meetup,
    create_offer,
    decline_offer,
    get_listing,
    get_meetup,
    list_listings,
    list_offers_for_listing,
    mark_sold,
    update_listing,
    withdraw_offer,
)
from app.models import MarketListing, User
from app.schemas.marketplace import (
    ListingCreate,
    ListingRead,
    ListingUpdate,
    MarkSoldPayload,
    MeetupConfirm,
    MeetupCreate,
    MeetupRead,
    OfferAction,
    OfferCreate,
    OfferRead,
)

router = APIRouter(prefix="/market", tags=["marketplace"])


@router.get("/categories", response_model=list[str])
async def get_market_categories(
    session: Session = Depends(get_session_dep),
):
    """Return distinct category values from active listings."""
    stmt = (
        select(col(MarketListing.category))
        .where(MarketListing.status == "active")
        .where(MarketListing.category.is_not(None))  # type: ignore[union-attr]
        .distinct()
    )
    categories = session.exec(stmt).all()
    return sorted([c for c in categories if c])


@router.post("/listings", response_model=ListingRead, status_code=status.HTTP_201_CREATED)
async def create_market_listing(
    payload: ListingCreate,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
    request_id: str = Depends(get_request_id_dep),
):
    enforce_kyc_approved(user)
    return create_listing(
        session,
        seller_id=user.id,
        data=payload,
        actor=str(user.id),
        request_id=request_id,
    )


@router.get("/listings", response_model=list[ListingRead])
async def get_market_listings(
    query: str | None = None,
    category: str | None = None,
    near: str | None = None,
    latitude: float | None = None,
    longitude: float | None = None,
    radius_km: float | None = Query(default=None, gt=0),
    min_price: float | None = Query(default=None, ge=0),
    max_price: float | None = Query(default=None, ge=0),
    min_alias: float | None = Query(default=None, alias="min", ge=0),
    max_alias: float | None = Query(default=None, alias="max", ge=0),
    status_filter: str = Query(default="active", alias="status"),
    session: Session = Depends(get_session_dep),
):
    effective_min = min_price if min_price is not None else min_alias
    effective_max = max_price if max_price is not None else max_alias

    near_filter = None
    if near:
        parts = [p.strip() for p in near.split(",")]
        if len(parts) != 3:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="near must be in format 'lat,lng,radius_km'",
            )
        try:
            lat_val = float(parts[0])
            lng_val = float(parts[1])
            radius_val = float(parts[2])
        except ValueError as exc:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="near contains invalid numeric values",
            ) from exc
        if radius_val <= 0:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="near radius_km must be greater than zero",
            )
        near_filter = (lat_val, lng_val, radius_val)
    elif latitude is not None or longitude is not None or radius_km is not None:
        if latitude is None or longitude is None or radius_km is None:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="latitude, longitude, and radius_km must be provided together",
            )
        near_filter = (latitude, longitude, radius_km)

    return list_listings(
        session,
        query=query,
        category=category,
        near=near_filter,
        min_price=effective_min,
        max_price=effective_max,
        status_filter=status_filter,
    )


@router.get("/listings/mine", response_model=list[ListingRead])
async def get_my_listings(
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
):
    """Return all listings owned by the current user (all statuses)."""
    return list_listings(session, seller_id=user.id, status_filter=None)


@router.get("/listings/{listing_id}", response_model=ListingRead)
async def get_market_listing(
    listing_id: int,
    session: Session = Depends(get_session_dep),
):
    return get_listing(session, listing_id=listing_id)


@router.patch("/listings/{listing_id}", response_model=ListingRead)
async def patch_market_listing(
    listing_id: int,
    payload: ListingUpdate,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
    request_id: str = Depends(get_request_id_dep),
):
    return update_listing(
        session,
        listing_id=listing_id,
        seller_id=user.id,
        data=payload,
        actor=str(user.id),
        request_id=request_id,
    )


@router.api_route("/listings/{listing_id}/mark_sold", methods=["POST", "PATCH"], response_model=ListingRead)
async def mark_listing_sold(
    listing_id: int,
    payload: MarkSoldPayload | None = None,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
    request_id: str = Depends(get_request_id_dep),
):
    return mark_sold(
        session,
        listing_id=listing_id,
        seller_id=user.id,
        payload=payload,
        actor=str(user.id),
        request_id=request_id,
    )


@router.post("/listings/{listing_id}/offer", response_model=OfferRead, status_code=status.HTTP_201_CREATED)
async def post_offer(
    listing_id: int,
    payload: OfferCreate,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
    request_id: str = Depends(get_request_id_dep),
):
    enforce_kyc_approved(user)
    return create_offer(
        session,
        listing_id=listing_id,
        from_user_id=user.id,
        data=payload,
        actor=str(user.id),
        request_id=request_id,
    )


@router.get("/listings/{listing_id}/offers", response_model=list[OfferRead])
async def get_offer_thread(
    listing_id: int,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
):
    return list_offers_for_listing(session, listing_id=listing_id, user_id=user.id)


@router.post("/offers/{offer_id}/counter", response_model=OfferRead)
async def post_offer_counter(
    offer_id: int,
    payload: OfferAction,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
    request_id: str = Depends(get_request_id_dep),
):
    return counter_offer(
        session,
        offer_id=offer_id,
        seller_id=user.id,
        data=payload,
        actor=str(user.id),
        request_id=request_id,
    )


@router.post("/offers/{offer_id}/accept", response_model=OfferRead)
async def post_offer_accept(
    offer_id: int,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
    request_id: str = Depends(get_request_id_dep),
):
    return accept_offer(
        session,
        offer_id=offer_id,
        seller_id=user.id,
        actor=str(user.id),
        request_id=request_id,
    )


@router.post("/offers/{offer_id}/decline", response_model=OfferRead)
async def post_offer_decline(
    offer_id: int,
    payload: OfferAction | None = None,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
    request_id: str = Depends(get_request_id_dep),
):
    return decline_offer(
        session,
        offer_id=offer_id,
        seller_id=user.id,
        data=payload,
        actor=str(user.id),
        request_id=request_id,
    )


@router.post("/offers/{offer_id}/withdraw", response_model=OfferRead)
async def post_offer_withdraw(
    offer_id: int,
    payload: OfferAction | None = None,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
    request_id: str = Depends(get_request_id_dep),
):
    return withdraw_offer(
        session,
        offer_id=offer_id,
        from_user_id=user.id,
        data=payload,
        actor=str(user.id),
        request_id=request_id,
    )


@router.post("/meetups", response_model=MeetupRead, status_code=status.HTTP_201_CREATED)
async def post_meetup(
    payload: MeetupCreate,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
    request_id: str = Depends(get_request_id_dep),
    settings: Settings = Depends(get_settings_dep),
):
    meetup, _otp = create_meetup(
        session,
        buyer_id=user.id,
        data=payload,
        actor=str(user.id),
        request_id=request_id,
    )
    if settings.env != "dev":
        meetup.otp_dev = None
    return meetup


@router.get("/meetups/{meetup_id}", response_model=MeetupRead)
async def get_meetup_record(
    meetup_id: int,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
):
    return get_meetup(session, meetup_id=meetup_id, user_id=user.id)


@router.post("/meetups/{meetup_id}/confirm", response_model=MeetupRead)
@limiter.limit("5/minute")
async def post_meetup_confirm(
    request: Request,
    meetup_id: int,
    payload: MeetupConfirm,
    session: Session = Depends(get_session_dep),
    user: User = Depends(get_current_user_dep),
    request_id: str = Depends(get_request_id_dep),
):
    return confirm_meetup(
        session,
        meetup_id=meetup_id,
        user_id=user.id,
        otp=payload.otp,
        actor=str(user.id),
        request_id=request_id,
    )
