"""DrawerItem model matching Flutter's drawer_item.dart."""

from datetime import datetime
from enum import Enum
from pydantic import BaseModel, Field

from .common import ItemUnit


class DrawerStatus(str, Enum):
    """Drawer item status."""
    organized = "organized"
    unorganized = "unorganized"


class DrawerItemBase(BaseModel):
    """Base drawer item fields."""
    name: str = Field(..., min_length=1, max_length=200)
    category: str = ""
    location: str = ""
    status: DrawerStatus = DrawerStatus.unorganized
    notes: str | None = None
    current_quantity: int = 0
    target_quantity: int = 0
    unit: ItemUnit = Field(default_factory=ItemUnit)
    styles: list[str] = Field(default_factory=list)


class DrawerItemCreate(DrawerItemBase):
    """Drawer item creation request."""
    pass


class DrawerItemUpdate(BaseModel):
    """Drawer item update request."""
    name: str | None = Field(None, min_length=1, max_length=200)
    category: str | None = None
    location: str | None = None
    status: DrawerStatus | None = None
    notes: str | None = None
    current_quantity: int | None = None
    target_quantity: int | None = None
    unit: ItemUnit | None = None
    styles: list[str] | None = None


class DrawerItem(DrawerItemBase):
    """Drawer item response model."""
    id: str
    user_id: str
    last_organized: datetime | None = None
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
        use_enum_values = True


class DrawerStatusResponse(BaseModel):
    """Drawer status summary response."""
    total_items: int
    organized: int
    unorganized: int
    percentage: float
    last_organized: datetime | None

