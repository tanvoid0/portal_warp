"""User preferences routes."""

from datetime import datetime, timezone

from fastapi import APIRouter, Depends

from ..database import get_user_prefs_collection
from ..auth.utils import get_current_user_id
from ..models.user_prefs import UserPrefs, UserPrefsUpdate

router = APIRouter()


# Default preferences
DEFAULT_PREFS = {
    "enabled_focus_areas": {
        "clothes": True,
        "skincare": True,
        "fitness": True,
        "cooking": True,
    },
    "priority": {
        "clothes": 5,
        "skincare": 3,
        "fitness": 4,
        "cooking": 3,
    },
    "weekly_target": {
        "clothes": 3,
        "skincare": 5,
        "fitness": 3,
        "cooking": 2,
    },
    "time_budget_minutes": 20,
    "difficulty_cap": 5,
    "default_energy": "medium",
}


def doc_to_prefs(doc: dict) -> dict:
    """Convert MongoDB document to UserPrefs response."""
    return {
        "user_id": doc["user_id"],
        "enabled_focus_areas": doc.get("enabled_focus_areas", DEFAULT_PREFS["enabled_focus_areas"]),
        "priority": doc.get("priority", DEFAULT_PREFS["priority"]),
        "weekly_target": doc.get("weekly_target", DEFAULT_PREFS["weekly_target"]),
        "time_budget_minutes": doc.get("time_budget_minutes", DEFAULT_PREFS["time_budget_minutes"]),
        "difficulty_cap": doc.get("difficulty_cap", DEFAULT_PREFS["difficulty_cap"]),
        "default_energy": doc.get("default_energy", DEFAULT_PREFS["default_energy"]),
        "created_at": doc["created_at"],
        "updated_at": doc["updated_at"],
    }


@router.get("", response_model=UserPrefs)
async def get_prefs(user_id: str = Depends(get_current_user_id)):
    """Get user preferences (creates default if not exists)."""
    collection = get_user_prefs_collection()
    
    doc = await collection.find_one({"user_id": user_id})
    
    if not doc:
        # Create default preferences
        now = datetime.now(timezone.utc)
        doc = {
            "user_id": user_id,
            **DEFAULT_PREFS,
            "created_at": now,
            "updated_at": now,
        }
        await collection.insert_one(doc)
    
    return doc_to_prefs(doc)


@router.put("", response_model=UserPrefs)
async def update_prefs(
    prefs: UserPrefsUpdate,
    user_id: str = Depends(get_current_user_id),
):
    """Update user preferences."""
    collection = get_user_prefs_collection()
    
    # Ensure document exists
    existing = await collection.find_one({"user_id": user_id})
    now = datetime.now(timezone.utc)
    
    if not existing:
        # Create with defaults, then apply updates
        doc = {
            "user_id": user_id,
            **DEFAULT_PREFS,
            "created_at": now,
            "updated_at": now,
        }
        await collection.insert_one(doc)
        existing = doc
    
    # Build update
    update_data = {"updated_at": now}
    prefs_dict = prefs.model_dump(exclude_unset=True)
    
    for key, value in prefs_dict.items():
        if key == "default_energy" and value:
            update_data["default_energy"] = value.value if hasattr(value, 'value') else value
        else:
            update_data[key] = value
    
    await collection.update_one({"user_id": user_id}, {"$set": update_data})
    
    updated = await collection.find_one({"user_id": user_id})
    return doc_to_prefs(updated)


