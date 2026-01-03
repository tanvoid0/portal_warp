"""QuestTemplate model matching Flutter's quest_template.dart."""

from datetime import datetime
from enum import Enum
from pydantic import BaseModel, Field


class FocusArea(str, Enum):
    """Focus areas for quests."""
    clothes = "clothes"
    skincare = "skincare"
    fitness = "fitness"
    cooking = "cooking"


class QuestTemplateBase(BaseModel):
    """Base quest template fields."""
    focus_area_id: FocusArea
    title: str = Field(..., min_length=1, max_length=200)
    duration_bucket: int = Field(default=10, description="2, 10, or 30 minutes")
    difficulty: int = Field(default=3, ge=1, le=5)
    cooldown_days: int = 0
    instructions: str = ""
    tags: list[str] = Field(default_factory=list)


class QuestTemplateCreate(QuestTemplateBase):
    """Quest template creation request."""
    pass


class QuestTemplateUpdate(BaseModel):
    """Quest template update request."""
    focus_area_id: FocusArea | None = None
    title: str | None = Field(None, min_length=1, max_length=200)
    duration_bucket: int | None = None
    difficulty: int | None = Field(None, ge=1, le=5)
    cooldown_days: int | None = None
    instructions: str | None = None
    tags: list[str] | None = None


class QuestTemplate(QuestTemplateBase):
    """Quest template response model."""
    id: str
    user_id: str
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
        use_enum_values = True

