"""ShoppingItem model matching Flutter's shopping_item.dart."""

from datetime import datetime
from enum import Enum
from pydantic import BaseModel, Field

from .common import ItemUnit


class ShoppingStatus(str, Enum):
    """Shopping item status."""
    pending = "pending"
    purchased = "purchased"


class ShoppingItemBase(BaseModel):
    """Base shopping item fields."""
    name: str = Field(..., min_length=1, max_length=200)
    category: str = ""
    quantity: int = 1
    priority: int = Field(default=1, ge=1, le=5)
    status: ShoppingStatus = ShoppingStatus.pending
    linked_quest_id: str | None = None
    unit: ItemUnit = Field(default_factory=ItemUnit)


class ShoppingItemCreate(ShoppingItemBase):
    """Shopping item creation request."""
    pass


class ShoppingItemUpdate(BaseModel):
    """Shopping item update request."""
    name: str | None = Field(None, min_length=1, max_length=200)
    category: str | None = None
    quantity: int | None = None
    priority: int | None = Field(None, ge=1, le=5)
    status: ShoppingStatus | None = None
    linked_quest_id: str | None = None
    unit: ItemUnit | None = None


class ShoppingItem(ShoppingItemBase):
    """Shopping item response model."""
    id: str
    user_id: str
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
        use_enum_values = True

