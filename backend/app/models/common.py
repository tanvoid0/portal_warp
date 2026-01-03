"""Common models shared across entities."""

from enum import Enum
from pydantic import BaseModel


class UnitType(str, Enum):
    """Unit types for quantities."""
    # Clothing
    pieces = "pieces"
    pairs = "pairs"
    items = "items"
    
    # Shopping
    kg = "kg"
    grams = "grams"
    liters = "liters"
    milliliters = "milliliters"
    bottles = "bottles"
    cans = "cans"
    boxes = "boxes"
    packs = "packs"
    bags = "bags"
    
    # General
    count = "count"
    custom = "custom"
    
    # Time-based (for plans)
    minutes = "minutes"
    hours = "hours"
    sets = "sets"
    reps = "reps"


class ItemUnit(BaseModel):
    """Unit representation with optional custom label."""
    type: UnitType = UnitType.count
    custom_unit: str = ""
    
    class Config:
        use_enum_values = True

