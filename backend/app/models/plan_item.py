"""PlanItem model matching Flutter's plan_item.dart."""

from datetime import datetime
from enum import Enum
from pydantic import BaseModel, Field

from .common import ItemUnit


class PlanStatus(str, Enum):
    """Plan item status."""
    pending = "pending"
    completed = "completed"


class PlanItemBase(BaseModel):
    """Base plan item fields."""
    title: str = Field(..., min_length=1, max_length=200)
    date: datetime
    time: str | None = None
    category: str = ""
    status: PlanStatus = PlanStatus.pending
    linked_quest_id: str | None = None
    notes: str | None = None
    quantity: int = 0
    unit: ItemUnit = Field(default_factory=ItemUnit)


class PlanItemCreate(PlanItemBase):
    """Plan item creation request."""
    pass


class PlanItemUpdate(BaseModel):
    """Plan item update request."""
    title: str | None = Field(None, min_length=1, max_length=200)
    date: datetime | None = None
    time: str | None = None
    category: str | None = None
    status: PlanStatus | None = None
    linked_quest_id: str | None = None
    notes: str | None = None
    quantity: int | None = None
    unit: ItemUnit | None = None


class PlanItem(PlanItemBase):
    """Plan item response model."""
    id: str
    user_id: str
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
        use_enum_values = True

