from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from backend.app.core.database import get_db
from backend.app.core.dependencies import get_current_user
from backend.app.models.user import User
from backend.app.schemas.note import NoteCreate, NoteRead
from backend.app.services.note_service import create_note, get_user_notes

router = APIRouter(
    prefix="/notes",
    tags=["Notes"]
)


@router.get("/")
async def get_my_notes(current_user: User = Depends(get_current_user)):
    return {
        "message": "Authorized",
        "user_id": current_user.id,
        "email": current_user.email
    }
    
@router.post("/", response_model=NoteRead)
async def create_note_endpoint(
    note_data: NoteCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    note = await create_note(
        db=db,
        title=note_data.title,
        content=note_data.content,
        owner_id=current_user.id
    )
    return note
