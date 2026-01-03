"""UserPrefs model matching Flutter's user_prefs.dart."""

from datetime import datetime
from enum import Enum
from pydantic import BaseModel, Field

from .quest_template import FocusArea


class EnergyLevel(str, Enum):
    """Energy level settings."""
    low = "low"
    medium = "medium"
    high = "high"


class UserPrefsBase(BaseModel):
    """Base user preferences fields."""
    enabled_focus_areas: dict[str, bool] = Field(default_factory=lambda: {
        "clothes": True,
        "skincare": True,
        "fitness": True,
        "cooking": True,
    })
    priority: dict[str, int] = Field(default_factory=lambda: {
        "clothes": 5,
        "skincare": 3,
        "fitness": 4,
        "cooking": 3,
    })
    weekly_target: dict[str, int] = Field(default_factory=lambda: {
        "clothes": 3,
        "skincare": 5,
        "fitness": 3,
        "cooking": 2,
    })
    time_budget_minutes: int = Field(default=20, description="10, 20, or 40")
    difficulty_cap: int = Field(default=5, ge=1, le=5)
    default_energy: EnergyLevel = EnergyLevel.medium


class UserPrefsUpdate(BaseModel):
    """User preferences update request."""
    enabled_focus_areas: dict[str, bool] | None = None
    priority: dict[str, int] | None = None
    weekly_target: dict[str, int] | None = None
    time_budget_minutes: int | None = None
    difficulty_cap: int | None = Field(None, ge=1, le=5)
    default_energy: EnergyLevel | None = None


class UserPrefs(UserPrefsBase):
    """User preferences response model."""
    user_id: str
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True
        use_enum_values = True


