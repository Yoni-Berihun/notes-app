from sqlalchemy import String 
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.base import Base

class User(Base):
    __tablename__ = "users"
    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(String, unique=True)
    hashed_password: Mapped[str]
    full_name: Mapped[str | None]

    notes = relationship("Note", back_populates="owner")
    