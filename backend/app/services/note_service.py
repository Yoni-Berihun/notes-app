from sqlalchemy.ext.asyncio import AsyncSession
from backend.app.repositories.note import create_note, get_note_by_id, update_note, delete_note
from backend.app.models.notes import Note
from fastapi import HTTPException, status

# Create a new note
async def create_new_note(
    db: AsyncSession, 
    title: str, 
    content: str, 
    owner_id: int
) -> Note:
    return await create_note(db=db, title=title, content=content, owner_id=owner_id)

# Get a note by ID
async def get_note_by_id_service(db: AsyncSession, note_id: int, user_id: int) -> Note | None:
    note = await get_note_by_id(db=db, note_id=note_id)
    if not note:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Note not found"
        )
    if note.owner_id != user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not authorized to access this note"
        )
    return note

# Update a note by ID
async def update_existing_note(
    db: AsyncSession, 
    note_id: int, 
    title: str | None = None, 
    content: str | None = None, 
    user_id: int
) -> Note:
    note = await get_note_by_id_service(db=db, note_id=note_id, user_id=user_id)
    return await update_note(db=db, note=note, title=title, content=content)

# Delete a note by ID
async def delete_existing_note(
    db: AsyncSession, 
    note_id: int, 
    user_id: int
) -> None:
    note = await get_note_by_id_service(db=db, note_id=note_id, user_id=user_id)
    await delete_note(db=db, note=note)
