"""Quest templates CRUD routes."""

from datetime import datetime, timezone
from uuid import uuid4

from fastapi import APIRouter, HTTPException, status, Depends, Query

from ..database import get_quest_templates_collection
from ..auth.utils import get_current_user_id
from ..models.quest_template import QuestTemplate, QuestTemplateCreate, QuestTemplateUpdate, FocusArea

router = APIRouter()


def doc_to_template(doc: dict) -> dict:
    """Convert MongoDB document to QuestTemplate response."""
    return {
        "id": doc["_id"],
        "user_id": doc["user_id"],
        "focus_area_id": doc["focus_area_id"],
        "title": doc["title"],
        "duration_bucket": doc.get("duration_bucket", 10),
        "difficulty": doc.get("difficulty", 3),
        "cooldown_days": doc.get("cooldown_days", 0),
        "instructions": doc.get("instructions", ""),
        "tags": doc.get("tags", []),
        "created_at": doc["created_at"],
        "updated_at": doc["updated_at"],
    }


# Default seed templates
SEED_TEMPLATES = [
    {"focus_area_id": "clothes", "title": "Remove 10 non-clothes items from drawer", "duration_bucket": 2, "difficulty": 1, "instructions": "Go through your drawer and remove any items that are not clothes."},
    {"focus_area_id": "clothes", "title": "Fold and file 10 shirts", "duration_bucket": 10, "difficulty": 2, "instructions": "Take 10 shirts and fold them properly, then organize them in your drawer."},
    {"focus_area_id": "clothes", "title": "Create 1 outfit combo and save it", "duration_bucket": 10, "difficulty": 2, "instructions": "Put together one complete outfit and take a photo or note it down."},
    {"focus_area_id": "clothes", "title": "Donate bag: pick 5 items", "duration_bucket": 10, "difficulty": 3, "instructions": "Select 5 clothing items you no longer wear to donate."},
    {"focus_area_id": "clothes", "title": "Full drawer reset", "duration_bucket": 30, "difficulty": 5, "instructions": "Completely reorganize your entire drawer from scratch."},
    {"focus_area_id": "skincare", "title": "Morning: Rinse + moisturize + SPF", "duration_bucket": 2, "difficulty": 1, "instructions": "Face: rinse/cleanse + moisturize + SPF. Quick and essential."},
    {"focus_area_id": "skincare", "title": "Night: Cleanse + moisturize", "duration_bucket": 10, "difficulty": 2, "instructions": "Evening routine: full cleanse followed by moisturizer."},
    {"focus_area_id": "skincare", "title": "SPF in the morning", "duration_bucket": 2, "difficulty": 1, "instructions": "Apply sunscreen as part of your morning routine."},
    {"focus_area_id": "fitness", "title": "Put on workout clothes", "duration_bucket": 2, "difficulty": 1, "instructions": "Just get into your workout clothes - that's the first step!"},
    {"focus_area_id": "fitness", "title": "Walk 10 minutes daily", "duration_bucket": 10, "difficulty": 2, "instructions": "Take a 10-minute walk, either outside or on a treadmill. Daily habit."},
    {"focus_area_id": "fitness", "title": "Workout: 2-3x per week", "duration_bucket": 30, "difficulty": 4, "instructions": "Complete a workout session. Start with 2x/week, build to 3x."},
    {"focus_area_id": "fitness", "title": "Posture check: Chest open, chin back", "duration_bucket": 2, "difficulty": 1, "instructions": "Posture cue: chest open, chin back, shoulders down - do this 3x/day."},
    {"focus_area_id": "cooking", "title": "Choose tomorrow's meal", "duration_bucket": 2, "difficulty": 1, "instructions": "Decide what you want to cook tomorrow and write it down."},
    {"focus_area_id": "cooking", "title": "Cook one simple meal", "duration_bucket": 30, "difficulty": 3, "instructions": "Cook one complete meal from start to finish."},
    {"focus_area_id": "cooking", "title": "Meal prep: 4 portions for the week", "duration_bucket": 30, "difficulty": 3, "instructions": "Meal prep once per week: prepare 4 portions of a meal."},
    {"focus_area_id": "cooking", "title": "Stock check: Essentials", "duration_bucket": 2, "difficulty": 1, "instructions": "Check if you have essentials: eggs, rice/pasta, frozen veg, protein, yogurt, sauces."},
]


@router.get("", response_model=list[QuestTemplate])
async def get_templates(
    user_id: str = Depends(get_current_user_id),
    focus_areas: str | None = Query(None, description="Comma-separated focus areas (e.g., 'clothes,fitness')"),
):
    """Get all quest templates for the current user."""
    collection = get_quest_templates_collection()
    
    query = {"user_id": user_id}
    if focus_areas:
        areas = [a.strip() for a in focus_areas.split(",")]
        query["focus_area_id"] = {"$in": areas}
    
    cursor = collection.find(query).sort([("focus_area_id", 1), ("difficulty", 1)])
    items = await cursor.to_list(length=1000)
    
    return [doc_to_template(doc) for doc in items]


@router.get("/{template_id}", response_model=QuestTemplate)
async def get_template(
    template_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Get a specific quest template."""
    collection = get_quest_templates_collection()
    
    doc = await collection.find_one({"_id": template_id, "user_id": user_id})
    if not doc:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Template not found")
    
    return doc_to_template(doc)


@router.post("", response_model=QuestTemplate, status_code=status.HTTP_201_CREATED)
async def create_template(
    template: QuestTemplateCreate,
    user_id: str = Depends(get_current_user_id),
):
    """Create a new quest template."""
    collection = get_quest_templates_collection()
    
    now = datetime.now(timezone.utc)
    doc = {
        "_id": str(uuid4()),
        "user_id": user_id,
        "focus_area_id": template.focus_area_id.value,
        "title": template.title,
        "duration_bucket": template.duration_bucket,
        "difficulty": template.difficulty,
        "cooldown_days": template.cooldown_days,
        "instructions": template.instructions,
        "tags": template.tags,
        "created_at": now,
        "updated_at": now,
    }
    
    await collection.insert_one(doc)
    return doc_to_template(doc)


@router.post("/seed", response_model=dict)
async def seed_templates(user_id: str = Depends(get_current_user_id)):
    """Seed default quest templates for the user (only if empty)."""
    collection = get_quest_templates_collection()
    
    # Check if user already has templates
    existing_count = await collection.count_documents({"user_id": user_id})
    if existing_count > 0:
        return {"message": "Templates already exist", "count": existing_count}
    
    # Seed templates
    now = datetime.now(timezone.utc)
    docs = []
    for i, template in enumerate(SEED_TEMPLATES):
        docs.append({
            "_id": str(uuid4()),
            "user_id": user_id,
            "focus_area_id": template["focus_area_id"],
            "title": template["title"],
            "duration_bucket": template["duration_bucket"],
            "difficulty": template["difficulty"],
            "cooldown_days": template.get("cooldown_days", 0),
            "instructions": template.get("instructions", ""),
            "tags": template.get("tags", []),
            "created_at": now,
            "updated_at": now,
        })
    
    await collection.insert_many(docs)
    return {"message": "Templates seeded successfully", "count": len(docs)}


@router.put("/{template_id}", response_model=QuestTemplate)
async def update_template(
    template_id: str,
    template: QuestTemplateUpdate,
    user_id: str = Depends(get_current_user_id),
):
    """Update a quest template."""
    collection = get_quest_templates_collection()
    
    existing = await collection.find_one({"_id": template_id, "user_id": user_id})
    if not existing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Template not found")
    
    update_data = {"updated_at": datetime.now(timezone.utc)}
    template_dict = template.model_dump(exclude_unset=True)
    
    for key, value in template_dict.items():
        if key == "focus_area_id" and value:
            update_data["focus_area_id"] = value.value if hasattr(value, 'value') else value
        else:
            update_data[key] = value
    
    await collection.update_one({"_id": template_id}, {"$set": update_data})
    
    updated = await collection.find_one({"_id": template_id})
    return doc_to_template(updated)


@router.delete("/{template_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_template(
    template_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Delete a quest template."""
    collection = get_quest_templates_collection()
    
    result = await collection.delete_one({"_id": template_id, "user_id": user_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Template not found")


