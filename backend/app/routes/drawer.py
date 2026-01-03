"""Drawer items CRUD routes."""

from datetime import datetime, timezone
from uuid import uuid4

from fastapi import APIRouter, HTTPException, status, Depends, Query

from ..database import get_drawer_items_collection
from ..auth.utils import get_current_user_id
from ..models.drawer_item import DrawerItem, DrawerItemCreate, DrawerItemUpdate, DrawerStatus, DrawerStatusResponse

router = APIRouter()


def doc_to_drawer_item(doc: dict) -> dict:
    """Convert MongoDB document to DrawerItem response."""
    return {
        "id": doc["_id"],
        "user_id": doc["user_id"],
        "name": doc["name"],
        "category": doc.get("category", ""),
        "location": doc.get("location", ""),
        "status": doc.get("status", "unorganized"),
        "notes": doc.get("notes"),
        "current_quantity": doc.get("current_quantity", 0),
        "target_quantity": doc.get("target_quantity", 0),
        "unit": doc.get("unit", {"type": "count", "custom_unit": ""}),
        "styles": doc.get("styles", []),
        "last_organized": doc.get("last_organized"),
        "created_at": doc["created_at"],
        "updated_at": doc["updated_at"],
    }


@router.get("", response_model=list[DrawerItem])
async def get_drawer_items(
    user_id: str = Depends(get_current_user_id),
    category: str | None = Query(None, description="Filter by category"),
    status: DrawerStatus | None = Query(None, description="Filter by status"),
    style: str | None = Query(None, description="Filter by style tag"),
):
    """Get all drawer items for the current user."""
    collection = get_drawer_items_collection()
    
    query = {"user_id": user_id}
    if category:
        query["category"] = category
    if status:
        query["status"] = status.value
    if style:
        query["styles"] = style
    
    cursor = collection.find(query).sort([("category", 1), ("name", 1)])
    items = await cursor.to_list(length=1000)
    
    return [doc_to_drawer_item(doc) for doc in items]


@router.get("/status", response_model=DrawerStatusResponse)
async def get_drawer_status(user_id: str = Depends(get_current_user_id)):
    """Get drawer organization status summary."""
    collection = get_drawer_items_collection()
    
    # Get all items
    cursor = collection.find({"user_id": user_id})
    items = await cursor.to_list(length=1000)
    
    total = len(items)
    organized = sum(1 for item in items if item.get("status") == "organized")
    unorganized = total - organized
    percentage = (organized / total) if total > 0 else 0.0
    
    # Find last organized date
    last_organized = None
    for item in items:
        item_last = item.get("last_organized")
        if item_last and (last_organized is None or item_last > last_organized):
            last_organized = item_last
    
    return DrawerStatusResponse(
        total_items=total,
        organized=organized,
        unorganized=unorganized,
        percentage=percentage,
        last_organized=last_organized,
    )


@router.get("/{item_id}", response_model=DrawerItem)
async def get_drawer_item(
    item_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Get a specific drawer item."""
    collection = get_drawer_items_collection()
    
    doc = await collection.find_one({"_id": item_id, "user_id": user_id})
    if not doc:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Drawer item not found")
    
    return doc_to_drawer_item(doc)


@router.post("", response_model=DrawerItem, status_code=status.HTTP_201_CREATED)
async def create_drawer_item(
    item: DrawerItemCreate,
    user_id: str = Depends(get_current_user_id),
):
    """Create a new drawer item."""
    collection = get_drawer_items_collection()
    
    now = datetime.now(timezone.utc)
    doc = {
        "_id": str(uuid4()),
        "user_id": user_id,
        "name": item.name,
        "category": item.category,
        "location": item.location,
        "status": item.status.value,
        "notes": item.notes,
        "current_quantity": item.current_quantity,
        "target_quantity": item.target_quantity,
        "unit": item.unit.model_dump(),
        "styles": item.styles,
        "last_organized": now if item.status == DrawerStatus.organized else None,
        "created_at": now,
        "updated_at": now,
    }
    
    await collection.insert_one(doc)
    return doc_to_drawer_item(doc)


@router.put("/{item_id}", response_model=DrawerItem)
async def update_drawer_item(
    item_id: str,
    item: DrawerItemUpdate,
    user_id: str = Depends(get_current_user_id),
):
    """Update a drawer item."""
    collection = get_drawer_items_collection()
    
    existing = await collection.find_one({"_id": item_id, "user_id": user_id})
    if not existing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Drawer item not found")
    
    now = datetime.now(timezone.utc)
    update_data = {"updated_at": now}
    item_dict = item.model_dump(exclude_unset=True)
    
    for key, value in item_dict.items():
        if key == "status" and value:
            status_val = value.value if hasattr(value, 'value') else value
            update_data["status"] = status_val
            # Update last_organized if status changed to organized
            if status_val == "organized" and existing.get("status") != "organized":
                update_data["last_organized"] = now
        elif key == "unit" and value:
            update_data["unit"] = value.model_dump() if hasattr(value, 'model_dump') else value
        else:
            update_data[key] = value
    
    await collection.update_one({"_id": item_id}, {"$set": update_data})
    
    updated = await collection.find_one({"_id": item_id})
    return doc_to_drawer_item(updated)


@router.patch("/{item_id}/organize", response_model=DrawerItem)
async def mark_item_organized(
    item_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Mark a drawer item as organized."""
    collection = get_drawer_items_collection()
    
    existing = await collection.find_one({"_id": item_id, "user_id": user_id})
    if not existing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Drawer item not found")
    
    now = datetime.now(timezone.utc)
    await collection.update_one(
        {"_id": item_id},
        {"$set": {"status": "organized", "last_organized": now, "updated_at": now}},
    )
    
    updated = await collection.find_one({"_id": item_id})
    return doc_to_drawer_item(updated)


@router.delete("/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_drawer_item(
    item_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Delete a drawer item."""
    collection = get_drawer_items_collection()
    
    result = await collection.delete_one({"_id": item_id, "user_id": user_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Drawer item not found")


