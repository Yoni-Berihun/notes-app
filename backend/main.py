from fastapi import FastAPI
from backend.app.routers import auth, notes

app = FastAPI()

app.include_router(auth.router)
app.include_router(notes.router)
