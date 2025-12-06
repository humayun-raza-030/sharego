from sqlmodel import Session

from app.db import engine, init_db
from app.models import User, Trip
from datetime import datetime, timedelta


def run_seed():
    init_db()
    with Session(engine) as session:
        if session.query(User).first():
            print("Seed skipped; data exists.")
            return
        user = User(email="demo@sharego.local", phone="0000000000", roles_csv="user")
        session.add(user)
        session.commit()
        session.refresh(user)
        trip = Trip(
            user_id=user.id,
            origin_airport="LHE",
            dest_airport="KHI",
            date=datetime.utcnow() + timedelta(days=7),
            capacity_kg=20.0,
            fee_pkr=1500,
        )
        session.add(trip)
        session.commit()
        print("Seeded demo user and trip.")


if __name__ == "__main__":
    run_seed()
