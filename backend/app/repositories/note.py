from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from backend.app.models.notes import Note

# Create a new note
async def create_note(db: AsyncSession, title: str, content: str, owner_id: int) -> Note:
    note = Note(title=title, content=content, owner_id=owner_id)
    db.add(note)
    await db.commit()
    await db.refresh(note)
    return note

# Get a note by ID
async def get_note_by_id(db: AsyncSession, note_id: int) -> Note | None:
    result = await db.execute(select(Note).where(Note.id == note_id))
    return result.scalar_one_or_none()

# Update a note
async def update_note(
    db: AsyncSession, 
    note: Note, 
    title: str | None = None, 
    content: str | None = None
) -> Note:
    if title is not None:
        note.title = title
    if content is not None:
        note.content = content
    db.add(note)
    await db.commit()
    await db.refresh(note)
    return note

# Optional: Delete a note
async def delete_note(db: AsyncSession, note: Note) -> None:
    await db.delete(note)
    await db.commit()
