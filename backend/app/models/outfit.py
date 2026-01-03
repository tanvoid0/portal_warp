"""Outfit model matching Flutter's outfit.dart."""

from datetime import datetime
from enum import Enum
from pydantic import BaseModel, Field


class OutfitType(str, Enum):
    """Outfit type."""
    casual = "casual"
    professional = "professional"


class OutfitBase(BaseModel):
    """Base outfit fields."""
    name: str = Field(..., min_length=1, max_length=100)
    type: OutfitType = OutfitType.casual
    top: str = ""
    bottom: str = ""
    shoes: str = ""
    layer: str = ""  # jacket/blazer
    accessories: str = ""
    notes: str = ""


class OutfitCreate(OutfitBase):
    """Outfit creation request."""
    pass


class OutfitUpdate(BaseModel):
    """Outfit update request."""
    name: str | None = Field(None, min_length=1, max_length=100)
    type: OutfitType | None = None
    top: str | None = None
    bottom: str | None = None
    shoes: str | None = None
    layer: str | None = None
    accessories: str | None = None
    notes: str | None = None


class Outfit(OutfitBase):
    """Outfit response model."""
    id: str
    user_id: str
    last_worn: datetime | None = None
    times_worn: int = 0
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
        use_enum_values = True

