# Portal Warp API - Docker & GCP Deployment Guide

This guide covers deploying the Portal Warp FastAPI backend to Google Cloud Platform (GCP) using Docker and Cloud Run.

## Prerequisites

1. **Google Cloud Account**
   - Create a GCP account at [cloud.google.com](https://cloud.google.com)
   - Enable billing (Cloud Run has a free tier)

2. **Google Cloud SDK (gcloud)**
   - Install from: https://cloud.google.com/sdk/docs/install
   - Authenticate: `gcloud auth login`
   - Set default project: `gcloud config set project YOUR_PROJECT_ID`

3. **Docker**
   - Install Docker Desktop: https://www.docker.com/products/docker-desktop

4. **MongoDB Atlas** (or self-hosted MongoDB)
   - Create free cluster at [MongoDB Atlas](https://cloud.mongodb.com)
   - Get connection string
   - Whitelist IP `0.0.0.0/0` for Cloud Run access

## Local Docker Testing

### 1. Build and Run with Docker Compose

```bash
cd backend

# Create .env file with your configuration
cat > .env << EOF
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/?retryWrites=true&w=majority
MONGODB_DB_NAME=portal_warp
JWT_SECRET_KEY=$(python -c "import secrets; print(secrets.token_hex(32))")
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
REFRESH_TOKEN_EXPIRE_DAYS=7
CORS_ORIGINS=*
EOF

# Build and start services
docker-compose up --build

# Or run in detached mode
docker-compose up -d --build
```

The API will be available at:
- API: http://localhost:8000
- Docs: http://localhost:8000/docs
- MongoDB: localhost:27017

### 2. Build Docker Image Manually

```bash
cd backend
docker build -t portal-warp-api:latest .
docker run -p 8000:8080 \
  -e MONGODB_URI="your-mongodb-uri" \
  -e JWT_SECRET_KEY="your-secret-key" \
  portal-warp-api:latest
```

## GCP Cloud Run Deployment

### Option 1: Manual Deployment (deploy.sh)

1. **Configure Environment Variables**

   Create a `.env` file in the `backend` directory:

   ```env
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/?retryWrites=true&w=majority
   MONGODB_DB_NAME=portal_warp
   JWT_SECRET_KEY=your-generated-secret-key-here
   JWT_ALGORITHM=HS256
   ACCESS_TOKEN_EXPIRE_MINUTES=1440
   REFRESH_TOKEN_EXPIRE_DAYS=7
   CORS_ORIGINS=*
   ```

   Generate a secure JWT secret:
   ```bash
   python -c "import secrets; print(secrets.token_hex(32))"
   ```

2. **Set GCP Project ID**

   ```bash
   export GCP_PROJECT_ID="your-project-id"
   export GCP_REGION="us-central1"  # Optional, defaults to us-central1
   ```

   Or edit `deploy.sh` and set:
   ```bash
   PROJECT_ID="your-project-id"
   REGION="us-central1"
   ```

3. **Run Deployment Script**

   ```bash
   cd backend
   chmod +x deploy.sh
   ./deploy.sh
   ```

   The script will:
   - Build the Docker image
   - Push to Google Container Registry (GCR)
   - Deploy to Cloud Run
   - Display the service URL

### Option 2: Cloud Build (CI/CD)

1. **Enable Required APIs**

   ```bash
   gcloud services enable cloudbuild.googleapis.com
   gcloud services enable run.googleapis.com
   gcloud services enable containerregistry.googleapis.com
   ```

2. **Set Substitution Variables**

   Create a file `cloudbuild-substitutions.yaml`:

   ```yaml
   _MONGODB_URI: "mongodb+srv://username:password@cluster.mongodb.net/?retryWrites=true&w=majority"
   _MONGODB_DB_NAME: "portal_warp"
   _JWT_SECRET_KEY: "your-generated-secret-key"
   _JWT_ALGORITHM: "HS256"
   _ACCESS_TOKEN_EXPIRE_MINUTES: "1440"
   _REFRESH_TOKEN_EXPIRE_DAYS: "7"
   _CORS_ORIGINS: "*"
   ```

   Or use Secret Manager (recommended for production):

   ```bash
   # Store secrets in Secret Manager
   echo -n "mongodb+srv://..." | gcloud secrets create mongodb-uri --data-file=-
   echo -n "your-secret-key" | gcloud secrets create jwt-secret-key --data-file=-
   
   # Grant Cloud Build access
   gcloud secrets add-iam-policy-binding mongodb-uri \
     --member="serviceAccount:PROJECT_NUMBER@cloudbuild.gserviceaccount.com" \
     --role="roles/secretmanager.secretAccessor"
   ```

3. **Trigger Build**

   ```bash
   cd backend
   gcloud builds submit --config=cloudbuild.yaml \
     --substitutions=_MONGODB_URI="...",_JWT_SECRET_KEY="..."
   ```

   Or connect to GitHub for automatic builds:
   - Go to Cloud Build > Triggers
   - Create trigger from GitHub repository
   - Use `cloudbuild.yaml` as build config

### Option 3: Using Secret Manager (Recommended for Production)

1. **Store Secrets**

   ```bash
   # Store MongoDB URI
   echo -n "mongodb+srv://username:password@cluster.mongodb.net/?retryWrites=true&w=majority" | \
     gcloud secrets create mongodb-uri --data-file=-
   
   # Store JWT Secret
   python -c "import secrets; print(secrets.token_hex(32))" | \
     gcloud secrets create jwt-secret-key --data-file=-
   ```

2. **Update cloudbuild.yaml**

   Modify the Cloud Run deploy step to use secrets:

   ```yaml
   - name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
     entrypoint: gcloud
     args:
       - 'run'
       - 'deploy'
       - 'portal-warp-api'
       - '--image'
       - 'gcr.io/$PROJECT_ID/portal-warp-api:latest'
       - '--region'
       - 'us-central1'
       - '--update-secrets'
       - 'MONGODB_URI=mongodb-uri:latest,JWT_SECRET_KEY=jwt-secret-key:latest'
   ```

3. **Grant Permissions**

   ```bash
   PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
   
   gcloud secrets add-iam-policy-binding mongodb-uri \
     --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
     --role="roles/secretmanager.secretAccessor"
   
   gcloud secrets add-iam-policy-binding jwt-secret-key \
     --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
     --role="roles/secretmanager.secretAccessor"
   ```

## Post-Deployment

### 1. Get Service URL

```bash
gcloud run services describe portal-warp-api \
  --region us-central1 \
  --format 'value(status.url)'
```

### 2. Test the API

```bash
# Health check
curl https://your-service-url.run.app/health

# API docs
open https://your-service-url.run.app/docs
```

### 3. Update CORS Origins

If your Flutter app is deployed, update CORS origins:

```bash
gcloud run services update portal-warp-api \
  --region us-central1 \
  --update-env-vars CORS_ORIGINS="https://your-flutter-app.com,https://your-flutter-app.web.app"
```

### 4. Set Up Custom Domain (Optional)

```bash
# Map custom domain
gcloud run domain-mappings create \
  --service portal-warp-api \
  --domain api.yourdomain.com \
  --region us-central1
```

## Monitoring & Logs

### View Logs

```bash
gcloud run services logs read portal-warp-api --region us-central1
```

### Monitor in Console

- Go to Cloud Run > portal-warp-api
- View metrics, logs, and revisions

## Cost Optimization

Cloud Run pricing:
- **Free tier**: 2 million requests/month, 360,000 GB-seconds, 180,000 vCPU-seconds
- **Pay-as-you-go**: $0.40 per million requests, $0.00002400 per GB-second, $0.00001000 per vCPU-second

Current configuration:
- Memory: 512Mi (adjustable)
- CPU: 1 (adjustable)
- Min instances: 0 (scales to zero)
- Max instances: 10 (adjustable)

To reduce costs:
```bash
gcloud run services update portal-warp-api \
  --region us-central1 \
  --memory 256Mi \
  --cpu 1 \
  --max-instances 5
```

## Troubleshooting

### Build Fails

```bash
# Check build logs
gcloud builds list --limit=5
gcloud builds log BUILD_ID
```

### Service Won't Start

```bash
# Check service logs
gcloud run services logs read portal-warp-api --region us-central1 --limit=50
```

### Connection Issues

- Verify MongoDB Atlas IP whitelist includes `0.0.0.0/0`
- Check MongoDB connection string format
- Verify environment variables are set correctly

### Update Service

```bash
# Rebuild and redeploy
cd backend
./deploy.sh
```

## Security Best Practices

1. **Never commit `.env` files** - Use Secret Manager
2. **Use strong JWT secrets** - Generate with `secrets.token_hex(32)`
3. **Restrict CORS origins** - Don't use `*` in production
4. **Enable authentication** - Remove `--allow-unauthenticated` if needed
5. **Use HTTPS only** - Cloud Run provides this by default
6. **Rotate secrets regularly** - Update JWT secret periodically

## Next Steps

1. Set up CI/CD with Cloud Build triggers
2. Configure monitoring and alerts
3. Set up custom domain
4. Implement rate limiting
5. Add API authentication if needed

