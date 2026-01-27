from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional

from schemas.base import BaseSchema
from uuid import UUID

class UserCreate(BaseSchema):
    full_name: Optional[str] = None
    email:EmailStr
    password:str
    
    
    
class UserUpdate(BaseSchema):
    full_name: Optional[str] = None
    email: Optional[EmailStr] = None
    
    
class UserResponse(BaseSchema):
    id: int
    full_name: Optional[str]
    email: EmailStr
    avatar_url: Optional[str]
    created_at: datetime
    
    
