from sqlalchemy.ext.asyncio import AsyncSession
from passlib.hash import bcrypt
from backend.app.core.token import create_access_token
from backend.app.repositories.user import (
    get_user_by_email,
    create_user,
    get_user_by_id,
    update_user,
    update_avatar
)

async def register_user(db:AsyncSession, full_name:str, email:str, password:str):
    existing_user =  await get_user_by_email(db, email)
    if existing_user:
        return "This user already exists"
         
    hashed_password = bcrypt.hash(password)
    
    new_user = await create_user(db, full_name, email, hashed_password)
    return new_user


async def authenticate_user(db:AsyncSession, email:str, password:str)  :
    existing_user =  await get_user_by_email(db, email)
    if not existing_user:
        return None
    if bcrypt.verify(password, existing_user.hashed_passowrd):
            return existing_user
    return None

async def login_user(db: AsyncSession, email: str, password: str):
    user = await authenticate_user(db, email, password)
    if not user:
        return None
    
    token_data = {"sub": str(user.id), "email": user.email}
    access_token = create_access_token(token_data)
    
    return {"access_token": access_token, "token_type": "bearer", "user": user}
    