"""Shopping items CRUD routes."""

from datetime import datetime, timezone
from uuid import uuid4

from fastapi import APIRouter, HTTPException, status, Depends, Query

from ..database import get_shopping_items_collection
from ..auth.utils import get_current_user_id
from ..models.shopping_item import ShoppingItem, ShoppingItemCreate, ShoppingItemUpdate, ShoppingStatus

router = APIRouter()


def doc_to_shopping_item(doc: dict) -> dict:
    """Convert MongoDB document to ShoppingItem response."""
    return {
        "id": doc["_id"],
        "user_id": doc["user_id"],
        "name": doc["name"],
        "category": doc.get("category", ""),
        "quantity": doc.get("quantity", 1),
        "priority": doc.get("priority", 1),
        "status": doc.get("status", "pending"),
        "linked_quest_id": doc.get("linked_quest_id"),
        "unit": doc.get("unit", {"type": "count", "custom_unit": ""}),
        "created_at": doc["created_at"],
        "updated_at": doc["updated_at"],
    }


@router.get("", response_model=list[ShoppingItem])
async def get_shopping_items(
    user_id: str = Depends(get_current_user_id),
    status: ShoppingStatus | None = Query(None, description="Filter by status"),
    category: str | None = Query(None, description="Filter by category"),
):
    """Get all shopping items for the current user."""
    collection = get_shopping_items_collection()
    
    query = {"user_id": user_id}
    if status:
        query["status"] = status.value
    if category:
        query["category"] = category
    
    cursor = collection.find(query).sort([("priority", -1), ("name", 1)])
    items = await cursor.to_list(length=1000)
    
    return [doc_to_shopping_item(doc) for doc in items]


@router.get("/pending", response_model=list[ShoppingItem])
async def get_pending_items(user_id: str = Depends(get_current_user_id)):
    """Get pending shopping items for the current user."""
    collection = get_shopping_items_collection()
    
    cursor = collection.find({
        "user_id": user_id,
        "status": "pending",
    }).sort([("priority", -1), ("name", 1)])
    
    items = await cursor.to_list(length=1000)
    return [doc_to_shopping_item(doc) for doc in items]


@router.get("/{item_id}", response_model=ShoppingItem)
async def get_shopping_item(
    item_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Get a specific shopping item."""
    collection = get_shopping_items_collection()
    
    doc = await collection.find_one({"_id": item_id, "user_id": user_id})
    if not doc:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Shopping item not found")
    
    return doc_to_shopping_item(doc)


@router.post("", response_model=ShoppingItem, status_code=status.HTTP_201_CREATED)
async def create_shopping_item(
    item: ShoppingItemCreate,
    user_id: str = Depends(get_current_user_id),
):
    """Create a new shopping item."""
    collection = get_shopping_items_collection()
    
    now = datetime.now(timezone.utc)
    doc = {
        "_id": str(uuid4()),
        "user_id": user_id,
        "name": item.name,
        "category": item.category,
        "quantity": item.quantity,
        "priority": item.priority,
        "status": item.status.value,
        "linked_quest_id": item.linked_quest_id,
        "unit": item.unit.model_dump(),
        "created_at": now,
        "updated_at": now,
    }
    
    await collection.insert_one(doc)
    return doc_to_shopping_item(doc)


@router.put("/{item_id}", response_model=ShoppingItem)
async def update_shopping_item(
    item_id: str,
    item: ShoppingItemUpdate,
    user_id: str = Depends(get_current_user_id),
):
    """Update a shopping item."""
    collection = get_shopping_items_collection()
    
    existing = await collection.find_one({"_id": item_id, "user_id": user_id})
    if not existing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Shopping item not found")
    
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
    return doc_to_shopping_item(updated)


@router.patch("/{item_id}/purchase", response_model=ShoppingItem)
async def mark_item_purchased(
    item_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Mark a shopping item as purchased."""
    collection = get_shopping_items_collection()
    
    existing = await collection.find_one({"_id": item_id, "user_id": user_id})
    if not existing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Shopping item not found")
    
    await collection.update_one(
        {"_id": item_id},
        {"$set": {"status": "purchased", "updated_at": datetime.now(timezone.utc)}},
    )
    
    updated = await collection.find_one({"_id": item_id})
    return doc_to_shopping_item(updated)


@router.delete("/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_shopping_item(
    item_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Delete a shopping item."""
    collection = get_shopping_items_collection()
    
    result = await collection.delete_one({"_id": item_id, "user_id": user_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Shopping item not found")


