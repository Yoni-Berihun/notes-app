from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from backend.app.models.user import User

# -----------------------------
# USER REPOSITORY FUNCTIONS
# -----------------------------

# Get a user by ID
async def get_user_by_id(db: AsyncSession, user_id: int) -> User | None:
    result = await db.execute(select(User).where(User.id == user_id))
    return result.scalar_one_or_none()

# Get a user by email (for login)
async def get_user_by_email(db: AsyncSession, email: str) -> User | None:
    result = await db.execute(select(User).where(User.email == email))
    return result.scalar_one_or_none()

# Create a new user
async def create_user(
    db: AsyncSession,
    full_name: str,
    email: str,
    hashed_password: str,
    avatar_url: str | None = None
) -> User:
    user = User(
        full_name=full_name,
        email=email,
        hashed_password=hashed_password,
        avatar_url=avatar_url
    )
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user

# Update user info
async def update_user(
    db: AsyncSession,
    user: User,
    full_name: str | None = None,
    email: str | None = None
) -> User:
    if full_name is not None:
        user.full_name = full_name
    if email is not None:
        user.email = email
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user

# Update user avatar
async def update_avatar(
    db: AsyncSession,
    user: User,
    avatar_url: str
) -> User:
    user.avatar_url = avatar_url
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user
