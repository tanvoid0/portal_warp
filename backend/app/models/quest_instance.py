"""QuestInstance model matching Flutter's quest_instance.dart."""

from datetime import datetime
from enum import Enum
from pydantic import BaseModel, Field


class QuestStatus(str, Enum):
    """Quest instance status."""
    todo = "todo"
    done = "done"
    skip = "skip"


class QuestInstanceBase(BaseModel):
    """Base quest instance fields."""
    date: datetime
    template_id: str
    status: QuestStatus = QuestStatus.todo
    xp_awarded: int = 0
    note: str | None = None


class QuestInstanceCreate(QuestInstanceBase):
    """Quest instance creation request."""
    pass


class QuestInstanceUpdate(BaseModel):
    """Quest instance update request."""
    date: datetime | None = None
    template_id: str | None = None
    status: QuestStatus | None = None
    xp_awarded: int | None = None
    note: str | None = None


class QuestInstance(QuestInstanceBase):
    """Quest instance response model."""
    id: str
    user_id: str
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
        use_enum_values = True

