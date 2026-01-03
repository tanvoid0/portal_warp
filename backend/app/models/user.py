"""User model."""

from datetime import datetime
from pydantic import BaseModel, EmailStr, Field


class UserBase(BaseModel):
    """Base user fields."""
    email: EmailStr
    name: str = Field(..., min_length=1, max_length=100)


class UserCreate(UserBase):
    """User creation request."""
    password: str = Field(..., min_length=6)


class UserUpdate(BaseModel):
    """User update request."""
    name: str | None = Field(None, min_length=1, max_length=100)


class User(UserBase):
    """User response model."""
    id: str
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True

