"""FastAPI application entry point."""

from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .config import get_settings
from .database import connect_to_mongo, close_mongo_connection

# Import routers
from .auth.routes import router as auth_router
from .routes.plans import router as plans_router
from .routes.outfits import router as outfits_router
from .routes.shopping import router as shopping_router
from .routes.templates import router as templates_router
from .routes.quests import router as quests_router
from .routes.drawer import router as drawer_router
from .routes.prefs import router as prefs_router

settings = get_settings()


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan manager for startup/shutdown events."""
    # Startup
    await connect_to_mongo()
    yield
    # Shutdown
    await close_mongo_connection()


app = FastAPI(
    title=settings.app_name,
    description="Backend API for Portal Warp - Personal organization and habit tracking",
    version="1.0.0",
    lifespan=lifespan,
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.get_cors_origins_list(),
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth_router, prefix="/auth", tags=["Authentication"])
app.include_router(plans_router, prefix="/plans", tags=["Plans"])
app.include_router(outfits_router, prefix="/outfits", tags=["Outfits"])
app.include_router(shopping_router, prefix="/shopping", tags=["Shopping"])
app.include_router(templates_router, prefix="/templates", tags=["Quest Templates"])
app.include_router(quests_router, prefix="/quests", tags=["Quest Instances"])
app.include_router(drawer_router, prefix="/drawer", tags=["Drawer Items"])
app.include_router(prefs_router, prefix="/prefs", tags=["User Preferences"])


@app.get("/", tags=["Health"])
async def root():
    """Health check endpoint."""
    return {"status": "ok", "app": settings.app_name}


@app.get("/health", tags=["Health"])
async def health_check():
    """Detailed health check."""
    return {
        "status": "healthy",
        "app": settings.app_name,
        "version": "1.0.0",
    }

