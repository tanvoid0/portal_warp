"""MongoDB database connection using Motor async driver."""

from motor.motor_asyncio import AsyncIOMotorClient, AsyncIOMotorDatabase
from .config import get_settings

settings = get_settings()

# Global database client
_client: AsyncIOMotorClient | None = None
_database: AsyncIOMotorDatabase | None = None


async def connect_to_mongo():
    """Connect to MongoDB on application startup."""
    global _client, _database
    _client = AsyncIOMotorClient(settings.mongodb_uri)
    _database = _client[settings.mongodb_db_name]
    
    # Verify connection
    await _client.admin.command("ping")
    print(f"Connected to MongoDB: {settings.mongodb_db_name}")


async def close_mongo_connection():
    """Close MongoDB connection on application shutdown."""
    global _client
    if _client:
        _client.close()
        print("MongoDB connection closed")


def get_database() -> AsyncIOMotorDatabase:
    """Get the database instance."""
    if _database is None:
        raise RuntimeError("Database not initialized. Call connect_to_mongo() first.")
    return _database


# Collection accessors
def get_users_collection():
    return get_database()["users"]


def get_plan_items_collection():
    return get_database()["plan_items"]


def get_outfits_collection():
    return get_database()["outfits"]


def get_shopping_items_collection():
    return get_database()["shopping_items"]


def get_quest_templates_collection():
    return get_database()["quest_templates"]


def get_quest_instances_collection():
    return get_database()["quest_instances"]


def get_drawer_items_collection():
    return get_database()["drawer_items"]


def get_user_prefs_collection():
    return get_database()["user_prefs"]

