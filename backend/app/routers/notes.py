from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from backend.app.core.dependencies import get_current_user
from backend.app.services.note_service import (
    create_new_note, get_note_by_id_service, update_existing_note, delete_existing_note
)
from backend.app.schemas.note import NoteCreate, NoteRead, NoteUpdate
from backend.app.models.user import User
from backend.app.core.database import get_db

router = APIRouter(
    prefix="/notes",
    tags=["Notes"]
)

# Route to create a new note
@router.post("/", response_model=NoteRead)
async def create_note(
    note_data: NoteCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return await create_new_note(
        db=db,
        title=note_data.title,
        content=note_data.content,
        owner_id=current_user.id
    )

# Route to get a note by ID
@router.get("/{note_id}", response_model=NoteRead)
async def get_note(
    note_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return await get_note_by_id_service(
        db=db,
        note_id=note_id,
        user_id=current_user.id
    )

# Route to update a note by ID
@router.put("/{note_id}", response_model=NoteRead)
async def update_note(
    note_id: int,
    note_data: NoteUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return await update_existing_note(
        db=db,
        note_id=note_id,
        title=note_data.title,
        content=note_data.content,
        user_id=current_user.id
    )

# Route to delete a note by ID
@router.delete("/{note_id}", response_model=dict)
async def delete_note(
    note_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    await delete_existing_note(db=db, note_id=note_id, user_id=current_user.id)
    return {"message": "Note deleted successfully"}
