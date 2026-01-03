"""Quest instances CRUD routes."""

from datetime import datetime, timezone, timedelta
from uuid import uuid4

from fastapi import APIRouter, HTTPException, status, Depends, Query

from ..database import get_quest_instances_collection
from ..auth.utils import get_current_user_id
from ..models.quest_instance import QuestInstance, QuestInstanceCreate, QuestInstanceUpdate, QuestStatus

router = APIRouter()


def doc_to_quest_instance(doc: dict) -> dict:
    """Convert MongoDB document to QuestInstance response."""
    return {
        "id": doc["_id"],
        "user_id": doc["user_id"],
        "date": doc["date"],
        "template_id": doc["template_id"],
        "status": doc.get("status", "todo"),
        "xp_awarded": doc.get("xp_awarded", 0),
        "note": doc.get("note"),
        "created_at": doc["created_at"],
        "updated_at": doc["updated_at"],
    }


@router.get("", response_model=list[QuestInstance])
async def get_quest_instances(
    user_id: str = Depends(get_current_user_id),
    date: datetime | None = Query(None, description="Filter by specific date"),
    start: datetime | None = Query(None, description="Start of date range"),
    end: datetime | None = Query(None, description="End of date range"),
    status: QuestStatus | None = Query(None, description="Filter by status"),
):
    """Get quest instances for the current user."""
    collection = get_quest_instances_collection()
    
    query = {"user_id": user_id}
    
    if date:
        start_of_day = datetime(date.year, date.month, date.day, tzinfo=timezone.utc)
        end_of_day = start_of_day + timedelta(days=1)
        query["date"] = {"$gte": start_of_day, "$lt": end_of_day}
    elif start and end:
        query["date"] = {"$gte": start, "$lte": end}
    
    if status:
        query["status"] = status.value
    
    cursor = collection.find(query).sort("date", 1)
    items = await cursor.to_list(length=1000)
    
    return [doc_to_quest_instance(doc) for doc in items]


@router.get("/today", response_model=list[QuestInstance])
async def get_today_quests(user_id: str = Depends(get_current_user_id)):
    """Get today's quest instances for the current user."""
    collection = get_quest_instances_collection()
    
    today = datetime.now(timezone.utc)
    start_of_day = datetime(today.year, today.month, today.day, tzinfo=timezone.utc)
    end_of_day = start_of_day + timedelta(days=1)
    
    cursor = collection.find({
        "user_id": user_id,
        "date": {"$gte": start_of_day, "$lt": end_of_day},
    }).sort("date", 1)
    
    items = await cursor.to_list(length=1000)
    return [doc_to_quest_instance(doc) for doc in items]


@router.get("/{instance_id}", response_model=QuestInstance)
async def get_quest_instance(
    instance_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Get a specific quest instance."""
    collection = get_quest_instances_collection()
    
    doc = await collection.find_one({"_id": instance_id, "user_id": user_id})
    if not doc:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Quest instance not found")
    
    return doc_to_quest_instance(doc)


@router.post("", response_model=QuestInstance, status_code=status.HTTP_201_CREATED)
async def create_quest_instance(
    instance: QuestInstanceCreate,
    user_id: str = Depends(get_current_user_id),
):
    """Create a new quest instance."""
    collection = get_quest_instances_collection()
    
    now = datetime.now(timezone.utc)
    doc = {
        "_id": str(uuid4()),
        "user_id": user_id,
        "date": instance.date,
        "template_id": instance.template_id,
        "status": instance.status.value,
        "xp_awarded": instance.xp_awarded,
        "note": instance.note,
        "created_at": now,
        "updated_at": now,
    }
    
    await collection.insert_one(doc)
    return doc_to_quest_instance(doc)


@router.put("/{instance_id}", response_model=QuestInstance)
async def update_quest_instance(
    instance_id: str,
    instance: QuestInstanceUpdate,
    user_id: str = Depends(get_current_user_id),
):
    """Update a quest instance (upsert behavior)."""
    collection = get_quest_instances_collection()
    
    existing = await collection.find_one({"_id": instance_id, "user_id": user_id})
    if not existing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Quest instance not found")
    
    update_data = {"updated_at": datetime.now(timezone.utc)}
    instance_dict = instance.model_dump(exclude_unset=True)
    
    for key, value in instance_dict.items():
        if key == "status" and value:
            update_data["status"] = value.value if hasattr(value, 'value') else value
        else:
            update_data[key] = value
    
    await collection.update_one({"_id": instance_id}, {"$set": update_data})
    
    updated = await collection.find_one({"_id": instance_id})
    return doc_to_quest_instance(updated)


@router.patch("/{instance_id}/complete", response_model=QuestInstance)
async def mark_quest_done(
    instance_id: str,
    xp: int = Query(default=10, description="XP to award"),
    user_id: str = Depends(get_current_user_id),
):
    """Mark a quest instance as done."""
    collection = get_quest_instances_collection()
    
    existing = await collection.find_one({"_id": instance_id, "user_id": user_id})
    if not existing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Quest instance not found")
    
    await collection.update_one(
        {"_id": instance_id},
        {"$set": {"status": "done", "xp_awarded": xp, "updated_at": datetime.now(timezone.utc)}},
    )
    
    updated = await collection.find_one({"_id": instance_id})
    return doc_to_quest_instance(updated)


@router.patch("/{instance_id}/skip", response_model=QuestInstance)
async def skip_quest(
    instance_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Skip a quest instance."""
    collection = get_quest_instances_collection()
    
    existing = await collection.find_one({"_id": instance_id, "user_id": user_id})
    if not existing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Quest instance not found")
    
    await collection.update_one(
        {"_id": instance_id},
        {"$set": {"status": "skip", "updated_at": datetime.now(timezone.utc)}},
    )
    
    updated = await collection.find_one({"_id": instance_id})
    return doc_to_quest_instance(updated)


@router.delete("/{instance_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_quest_instance(
    instance_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Delete a quest instance."""
    collection = get_quest_instances_collection()
    
    result = await collection.delete_one({"_id": instance_id, "user_id": user_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Quest instance not found")


