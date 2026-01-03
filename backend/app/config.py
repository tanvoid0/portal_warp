"""Application configuration using Pydantic Settings."""

import json
from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""
    
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        # Prevent pydantic-settings from auto-parsing complex types
        env_ignore_empty=True,
    )
    
    # App
    app_name: str = "Portal Warp API"
    debug: bool = False
    
    # MongoDB
    mongodb_uri: str = "mongodb://localhost:27017"
    mongodb_db_name: str = "portal_warp"
    
    # JWT
    jwt_secret_key: str = "your-super-secret-key-change-in-production"
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 1440  # 1 day
    refresh_token_expire_days: int = 7
    
    # CORS - can be passed as JSON array or comma-separated string
    # Store as string to avoid pydantic-settings automatic JSON parsing
    cors_origins: str = "*"
    
    def get_cors_origins_list(self) -> list[str]:
        """Get CORS origins as a list.
        
        Supports:
        - "*" -> ["*"]
        - "http://localhost:3000,http://localhost:8080" -> ["http://localhost:3000", "http://localhost:8080"]
        - '["*"]' -> ["*"] (JSON array string)
        """
        if not self.cors_origins:
            return ["*"]
        
        # Try to parse as JSON first
        try:
            parsed = json.loads(self.cors_origins)
            if isinstance(parsed, list):
                return [str(item) for item in parsed]
        except (json.JSONDecodeError, TypeError):
            pass
        
        # If not JSON, treat as comma-separated string
        # Handle "*" specially
        if self.cors_origins.strip() == "*":
            return ["*"]
        
        # Split by comma and strip whitespace
        origins = [origin.strip() for origin in self.cors_origins.split(",") if origin.strip()]
        return origins if origins else ["*"]


@lru_cache
def get_settings() -> Settings:
    """Get cached settings instance."""
    return Settings()

