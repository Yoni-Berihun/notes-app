from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional
from schemas.base import BaseSchema
from uuid import UUID


class NoteCreate (BaseSchema):
    title:str
    content:str
    
class NoteUpdate(BaseSchema):
    title:Optional[str] = None
    content:Optional[str] = None
    
class NoteRead(BaseSchema):
    id:UUID
    title:str
    content:str
    created_at:datetime
    class Config:
        orm_mode = True
    