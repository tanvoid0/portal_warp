#!/bin/bash
# Cloud Run Deployment Script for Portal Warp API

set -e

# Configuration - Update these values
PROJECT_ID="${GCP_PROJECT_ID:-your-project-id}"
REGION="${GCP_REGION:-us-central1}"
SERVICE_NAME="portal-warp-api"
IMAGE_NAME="gcr.io/${PROJECT_ID}/${SERVICE_NAME}"

echo "🚀 Deploying Portal Warp API to Cloud Run..."

# Check prerequisites
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install Docker Desktop."
    exit 1
fi

if ! command -v gcloud &> /dev/null; then
    echo "❌ gcloud CLI not found. Install from: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Function to safely read a specific variable from .env
read_env_var() {
    local var_name=$1
    if [ -f .env ]; then
        grep -E "^${var_name}=" .env 2>/dev/null | cut -d '=' -f2- | sed 's/^"//;s/"$//' | xargs
    fi
}

# Load environment variables from .env
if [ -f .env ]; then
    echo "📄 Loading variables from .env..."
    MONGODB_URI=$(read_env_var "MONGODB_URI")
    MONGODB_DB_NAME=$(read_env_var "MONGODB_DB_NAME")
    JWT_SECRET_KEY=$(read_env_var "JWT_SECRET_KEY")
    JWT_ALGORITHM=$(read_env_var "JWT_ALGORITHM")
    ACCESS_TOKEN_EXPIRE_MINUTES=$(read_env_var "ACCESS_TOKEN_EXPIRE_MINUTES")
    REFRESH_TOKEN_EXPIRE_DAYS=$(read_env_var "REFRESH_TOKEN_EXPIRE_DAYS")
    CORS_ORIGINS=$(read_env_var "CORS_ORIGINS")
else
    echo "⚠️  No .env file found. Using defaults or environment variables."
fi

# Set defaults if not provided
MONGODB_URI=${MONGODB_URI:-"mongodb://localhost:27017"}
MONGODB_DB_NAME=${MONGODB_DB_NAME:-"portal_warp"}
JWT_SECRET_KEY=${JWT_SECRET_KEY:-"change-me-in-production"}
JWT_ALGORITHM=${JWT_ALGORITHM:-"HS256"}
ACCESS_TOKEN_EXPIRE_MINUTES=${ACCESS_TOKEN_EXPIRE_MINUTES:-"1440"}
REFRESH_TOKEN_EXPIRE_DAYS=${REFRESH_TOKEN_EXPIRE_DAYS:-"7"}
CORS_ORIGINS=${CORS_ORIGINS:-"*"}

# Validate required variables
if [ "$MONGODB_URI" = "mongodb://localhost:27017" ] && [ -z "$MONGODB_URI" ]; then
    echo "⚠️  Warning: Using default MongoDB URI. Set MONGODB_URI in .env for production."
fi

if [ "$JWT_SECRET_KEY" = "change-me-in-production" ] || [ -z "$JWT_SECRET_KEY" ]; then
    echo "⚠️  Warning: Using default JWT secret. Generate a secure key for production."
    echo "   Generate one with: python -c \"import secrets; print(secrets.token_hex(32))\""
fi

# Build Docker image
echo "🔨 Building Docker image..."
docker build -f Dockerfile -t ${IMAGE_NAME}:latest .

# Authenticate with GCP
echo "🔐 Authenticating with GCP..."
gcloud auth configure-docker --quiet

# Push to GCR
echo "📤 Pushing to Google Container Registry..."
docker push ${IMAGE_NAME}:latest

# Set project
echo "📦 Setting GCP project..."
gcloud config set project ${PROJECT_ID} --quiet

# Build environment variables string
ENV_VARS="MONGODB_URI=${MONGODB_URI},MONGODB_DB_NAME=${MONGODB_DB_NAME},JWT_SECRET_KEY=${JWT_SECRET_KEY},JWT_ALGORITHM=${JWT_ALGORITHM},ACCESS_TOKEN_EXPIRE_MINUTES=${ACCESS_TOKEN_EXPIRE_MINUTES},REFRESH_TOKEN_EXPIRE_DAYS=${REFRESH_TOKEN_EXPIRE_DAYS},CORS_ORIGINS=${CORS_ORIGINS}"

# Deploy to Cloud Run
echo "🚀 Deploying to Cloud Run..."
gcloud run deploy ${SERVICE_NAME} \
  --image ${IMAGE_NAME}:latest \
  --region ${REGION} \
  --platform managed \
  --allow-unauthenticated \
  --memory 512Mi \
  --cpu 1 \
  --timeout 300 \
  --min-instances 0 \
  --max-instances 10 \
  --concurrency 80 \
  --set-env-vars "${ENV_VARS}" \
  --project=${PROJECT_ID}

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🌐 Service URL:"
SERVICE_URL=$(gcloud run services describe ${SERVICE_NAME} --region ${REGION} --format 'value(status.url)' --project=${PROJECT_ID})
echo "${SERVICE_URL}"
echo ""
echo "📚 API Documentation:"
echo "${SERVICE_URL}/docs"
echo ""
echo "Press Enter to exit..."
read

