from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from app.database import engine, Base
from app.api import rooms, guests, checkinout, messages
from app import models  # noqa: F401 — ensures models are registered before create_all

Base.metadata.create_all(bind=engine)

from app.seed import seed  # noqa: E402
seed()

app = FastAPI(title="Hotel Management")

app.include_router(rooms.router)
app.include_router(guests.router)
app.include_router(checkinout.router)
app.include_router(messages.router)

app.mount("/", StaticFiles(directory="static", html=True), name="static")
