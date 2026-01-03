"""Outfits CRUD routes."""

from datetime import datetime, timezone
from uuid import uuid4

from fastapi import APIRouter, HTTPException, status, Depends, Query

from ..database import get_outfits_collection
from ..auth.utils import get_current_user_id
from ..models.outfit import Outfit, OutfitCreate, OutfitUpdate, OutfitType

router = APIRouter()


def doc_to_outfit(doc: dict) -> dict:
    """Convert MongoDB document to Outfit response."""
    return {
        "id": doc["_id"],
        "user_id": doc["user_id"],
        "name": doc["name"],
        "type": doc.get("type", "casual"),
        "top": doc.get("top", ""),
        "bottom": doc.get("bottom", ""),
        "shoes": doc.get("shoes", ""),
        "layer": doc.get("layer", ""),
        "accessories": doc.get("accessories", ""),
        "notes": doc.get("notes", ""),
        "last_worn": doc.get("last_worn"),
        "times_worn": doc.get("times_worn", 0),
        "created_at": doc["created_at"],
        "updated_at": doc["updated_at"],
    }


@router.get("", response_model=list[Outfit])
async def get_outfits(
    user_id: str = Depends(get_current_user_id),
    type: OutfitType | None = Query(None, description="Filter by outfit type"),
):
    """Get all outfits for the current user."""
    collection = get_outfits_collection()
    
    query = {"user_id": user_id}
    if type:
        query["type"] = type.value
    
    cursor = collection.find(query).sort("name", 1)
    items = await cursor.to_list(length=1000)
    
    return [doc_to_outfit(doc) for doc in items]


@router.get("/{outfit_id}", response_model=Outfit)
async def get_outfit(
    outfit_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Get a specific outfit."""
    collection = get_outfits_collection()
    
    doc = await collection.find_one({"_id": outfit_id, "user_id": user_id})
    if not doc:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Outfit not found")
    
    return doc_to_outfit(doc)


@router.post("", response_model=Outfit, status_code=status.HTTP_201_CREATED)
async def create_outfit(
    outfit: OutfitCreate,
    user_id: str = Depends(get_current_user_id),
):
    """Create a new outfit."""
    collection = get_outfits_collection()
    
    now = datetime.now(timezone.utc)
    doc = {
        "_id": str(uuid4()),
        "user_id": user_id,
        "name": outfit.name,
        "type": outfit.type.value,
        "top": outfit.top,
        "bottom": outfit.bottom,
        "shoes": outfit.shoes,
        "layer": outfit.layer,
        "accessories": outfit.accessories,
        "notes": outfit.notes,
        "last_worn": None,
        "times_worn": 0,
        "created_at": now,
        "updated_at": now,
    }
    
    await collection.insert_one(doc)
    return doc_to_outfit(doc)


@router.put("/{outfit_id}", response_model=Outfit)
async def update_outfit(
    outfit_id: str,
    outfit: OutfitUpdate,
    user_id: str = Depends(get_current_user_id),
):
    """Update an outfit."""
    collection = get_outfits_collection()
    
    existing = await collection.find_one({"_id": outfit_id, "user_id": user_id})
    if not existing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Outfit not found")
    
    update_data = {"updated_at": datetime.now(timezone.utc)}
    outfit_dict = outfit.model_dump(exclude_unset=True)
    
    for key, value in outfit_dict.items():
        if key == "type" and value:
            update_data["type"] = value.value if hasattr(value, 'value') else value
        else:
            update_data[key] = value
    
    await collection.update_one({"_id": outfit_id}, {"$set": update_data})
    
    updated = await collection.find_one({"_id": outfit_id})
    return doc_to_outfit(updated)


@router.patch("/{outfit_id}/worn", response_model=Outfit)
async def mark_outfit_worn(
    outfit_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Mark an outfit as worn (increments times_worn and updates last_worn)."""
    collection = get_outfits_collection()
    
    existing = await collection.find_one({"_id": outfit_id, "user_id": user_id})
    if not existing:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Outfit not found")
    
    now = datetime.now(timezone.utc)
    await collection.update_one(
        {"_id": outfit_id},
        {
            "$set": {"last_worn": now, "updated_at": now},
            "$inc": {"times_worn": 1},
        },
    )
    
    updated = await collection.find_one({"_id": outfit_id})
    return doc_to_outfit(updated)


@router.delete("/{outfit_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_outfit(
    outfit_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Delete an outfit."""
    collection = get_outfits_collection()
    
    result = await collection.delete_one({"_id": outfit_id, "user_id": user_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Outfit not found")


