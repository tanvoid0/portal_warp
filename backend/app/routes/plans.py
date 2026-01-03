"""Plan items CRUD routes."""

from datetime import datetime, timezone, timedelta
from uuid import uuid4

from fastapi import APIRouter, HTTPException, status, Depends, Query

from ..database import get_plan_items_collection
from ..auth.utils import get_current_user_id
from ..models.plan_item import PlanItem, PlanItemCreate, PlanItemUpdate, PlanStatus

router = APIRouter()


def doc_to_plan_item(doc: dict) -> dict:
    """Convert MongoDB document to PlanItem response."""
    return {
        "id": doc["_id"],
        "user_id": doc["user_id"],
        "title": doc["title"],
        "date": doc["date"],
        "time": doc.get("time"),
        "category": doc.get("category", ""),
        "status": doc.get("status", "pending"),
        "linked_quest_id": doc.get("linked_quest_id"),
        "notes": doc.get("notes"),
        "quantity": doc.get("quantity", 0),
        "unit": doc.get("unit", {"type": "count", "custom_unit": ""}),
        "created_at": doc["created_at"],
        "updated_at": doc["updated_at"],
    }


@router.get("", response_model=list[PlanItem])
async def get_plan_items(
    user_id: str = Depends(get_current_user_id),
    date: datetime | None = Query(None, description="Filter by specific date"),
    status: PlanStatus | None = Query(None, description="Filter by status"),
):
    """Get all plan items for the current user."""
    collection = get_plan_items_collection()
    
    query = {"user_id": user_id}
    
    if date:
        # Filter by date (same day)
        start_of_day = datetime(date.year, date.month, date.day, tzinfo=timezone.utc)
        end_of_day = start_of_day + timedelta(days=1)
        query["date"] = {"$gte": start_of_day, "$lt": end_of_day}
    
    if status:
        query["status"] = status.value
    
    cursor = collection.find(query).sort("date", 1)
    items = await cursor.to_list(length=1000)
    
    return [doc_to_plan_item(doc) for doc in items]


@router.get("/today", response_model=list[PlanItem])
async def get_today_plans(user_id: str = Depends(get_current_user_id)):
    """Get today's plan items for the current user."""
    collection = get_plan_items_collection()
    
    today = datetime.now(timezone.utc)
    start_of_day = datetime(today.year, today.month, today.day, tzinfo=timezone.utc)
    end_of_day = start_of_day + timedelta(days=1)
    
    cursor = collection.find({
        "user_id": user_id,
        "date": {"$gte": start_of_day, "$lt": end_of_day},
    }).sort("date", 1)
    
    items = await cursor.to_list(length=1000)
    return [doc_to_plan_item(doc) for doc in items]


@router.get("/{item_id}", response_model=PlanItem)
async def get_plan_item(
    item_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Get a specific plan item."""
    collection = get_plan_items_collection()
    
    doc = await collection.find_one({"_id": item_id, "user_id": user_id})
    if not doc:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Plan item not found")
    
    return doc_to_plan_item(doc)


@router.post("", response_model=PlanItem, status_code=status.HTTP_201_CREATED)
async def create_plan_item(
    item: PlanItemCreate,
    user_id: str = Depends(get_current_user_id),
):
    """Create a new plan item."""
    collection = get_plan_items_collection()
    
    now = datetime.now(timezone.utc)
    doc = {
        "_id": str(uuid4()),
        "user_id": user_id,
        "title": item.title,
        "date": item.date,
        "time": item.time,
        "category": item.category,
        "status": item.status.value,
        "linked_quest_id": item.linked_quest_id,
        "notes": item.notes,
        "quantity": item.quantity,
        "unit": item.unit.model_dump(),
        "created_at": now,
        "updated_at": now,
    }
    
    await collection.insert_one(doc)
    return doc_to_plan_item(doc)


@router.put("/{item_id}", response_model=PlanItem)
async def update_plan_item(
    item_id: str,
    item: PlanItemUpdate,
    user_id: str = Depends(get_current_user_id),
):
    """Update a plan item."""
    collection = get_plan_items_collection()
    
    # Check exists
    existing = await collection.find_one({"_id": item_id, "user_id": user_id})
    if not existing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Plan item not found")
    
    # Build update
    update_data = {"updated_at": datetime.now(timezone.utc)}
    item_dict = item.model_dump(exclude_unset=True)
    
    for key, value in item_dict.items():
        if key == "status" and value:
            update_data["status"] = value.value if hasattr(value, 'value') else value
        elif key == "unit" and value:
            update_data["unit"] = value.model_dump() if hasattr(value, 'model_dump') else value
        else:
            update_data[key] = value
    
    await collection.update_one({"_id": item_id}, {"$set": update_data})
    
    updated = await collection.find_one({"_id": item_id})
    return doc_to_plan_item(updated)


@router.patch("/{item_id}/complete", response_model=PlanItem)
async def mark_plan_complete(
    item_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Mark a plan item as completed."""
    collection = get_plan_items_collection()
    
    existing = await collection.find_one({"_id": item_id, "user_id": user_id})
    if not existing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Plan item not found")
    
    await collection.update_one(
        {"_id": item_id},
        {"$set": {"status": "completed", "updated_at": datetime.now(timezone.utc)}},
    )
    
    updated = await collection.find_one({"_id": item_id})
    return doc_to_plan_item(updated)


@router.delete("/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_plan_item(
    item_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Delete a plan item."""
    collection = get_plan_items_collection()
    
    result = await collection.delete_one({"_id": item_id, "user_id": user_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Plan item not found")


