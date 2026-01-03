# Portal Warp Backend

FastAPI backend for Portal Warp - Personal organization and habit tracking app.

## Tech Stack

- **FastAPI** - Modern, fast Python web framework
- **MongoDB Atlas** - Free cloud database (512MB)
- **Motor** - Async MongoDB driver
- **JWT** - Token-based authentication
- **PythonAnywhere** - Hosting platform

## Local Development

### 1. Create Virtual Environment

```bash
cd backend
python -m venv venv

# Windows
venv\Scripts\activate

# Linux/Mac
source venv/bin/activate
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

### 3. Configure Environment

Create a `.env` file in the `backend` folder:

```env
# Application
APP_NAME="Portal Warp API"
DEBUG=true

# MongoDB Atlas Connection
# Get your connection string from MongoDB Atlas:
# 1. Go to https://cloud.mongodb.com
# 2. Create a free cluster (M0 Sandbox - 512MB)
# 3. Create a database user
# 4. Whitelist your IP (or 0.0.0.0/0 for any IP)
# 5. Get connection string and replace <password>
MONGODB_URI="mongodb+srv://username:password@cluster.xxxxx.mongodb.net/?retryWrites=true&w=majority"
MONGODB_DB_NAME="portal_warp"

# JWT Configuration
# Generate a secure secret key with: python -c "import secrets; print(secrets.token_hex(32))"
JWT_SECRET_KEY="your-super-secret-key-change-in-production"
JWT_ALGORITHM="HS256"
ACCESS_TOKEN_EXPIRE_MINUTES=1440
REFRESH_TOKEN_EXPIRE_DAYS=7

# CORS Origins
CORS_ORIGINS=["*"]
```

### 4. Run Development Server

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 5. Access API Docs

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## MongoDB Atlas Setup

1. Go to [MongoDB Atlas](https://cloud.mongodb.com)
2. Create a free account
3. Create a new cluster (M0 Sandbox - FREE)
4. Create a database user with read/write permissions
5. Network Access: Add `0.0.0.0/0` to allow all IPs (required for PythonAnywhere)
6. Get your connection string from "Connect" > "Connect your application"

## PythonAnywhere Deployment

### 1. Create Account

Sign up at [PythonAnywhere](https://www.pythonanywhere.com) (free tier works!)

### 2. Upload Code

Option A - Git:
```bash
# In PythonAnywhere Bash console
cd ~
git clone YOUR_REPO_URL portal_warp
```

Option B - Upload ZIP:
- Go to Files tab
- Upload and extract your backend folder

### 3. Create Virtual Environment

```bash
cd ~/portal_warp/backend
mkvirtualenv --python=/usr/bin/python3.10 portal_warp_env
pip install -r requirements.txt
```

### 4. Configure Web App

1. Go to **Web** tab
2. Click **Add a new web app**
3. Select **Manual configuration** (NOT Flask!)
4. Choose **Python 3.10**

### 5. Configure WSGI

In the **WSGI configuration file** section, click the link and replace contents with:

```python
import sys
import os

# Add your project to the path
path = '/home/YOUR_USERNAME/portal_warp/backend'
if path not in sys.path:
    sys.path.insert(0, path)

# Set environment variables
os.environ['MONGODB_URI'] = 'mongodb+srv://...'
os.environ['MONGODB_DB_NAME'] = 'portal_warp'
os.environ['JWT_SECRET_KEY'] = 'your-secure-secret-key'
os.environ['JWT_ALGORITHM'] = 'HS256'
os.environ['ACCESS_TOKEN_EXPIRE_MINUTES'] = '1440'
os.environ['REFRESH_TOKEN_EXPIRE_DAYS'] = '7'

# Import the ASGI app
from app.main import app

# PythonAnywhere now supports ASGI
application = app
```

### 6. Set Virtualenv Path

In Web tab, set **Virtualenv** to:
```
/home/YOUR_USERNAME/.virtualenvs/portal_warp_env
```

### 7. Reload Web App

Click the green **Reload** button.

### 8. Access Your API

Your API will be available at:
```
https://YOUR_USERNAME.pythonanywhere.com/
```

## API Endpoints

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register` | Register new user |
| POST | `/auth/login` | Login and get tokens |
| POST | `/auth/refresh` | Refresh access token |
| GET | `/auth/me` | Get current user |

### Plans

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/plans` | List all plans |
| GET | `/plans/today` | Get today's plans |
| POST | `/plans` | Create plan |
| PUT | `/plans/{id}` | Update plan |
| PATCH | `/plans/{id}/complete` | Mark complete |
| DELETE | `/plans/{id}` | Delete plan |

### Outfits

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/outfits` | List all outfits |
| POST | `/outfits` | Create outfit |
| PUT | `/outfits/{id}` | Update outfit |
| PATCH | `/outfits/{id}/worn` | Mark as worn |
| DELETE | `/outfits/{id}` | Delete outfit |

### Shopping

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/shopping` | List all items |
| GET | `/shopping/pending` | Get pending items |
| POST | `/shopping` | Create item |
| PUT | `/shopping/{id}` | Update item |
| PATCH | `/shopping/{id}/purchase` | Mark purchased |
| DELETE | `/shopping/{id}` | Delete item |

### Quest Templates

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/templates` | List templates |
| POST | `/templates` | Create template |
| POST | `/templates/seed` | Seed defaults |
| PUT | `/templates/{id}` | Update template |
| DELETE | `/templates/{id}` | Delete template |

### Quest Instances

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/quests` | List instances |
| GET | `/quests/today` | Get today's quests |
| POST | `/quests` | Create instance |
| PUT | `/quests/{id}` | Update instance |
| PATCH | `/quests/{id}/complete` | Mark done |
| PATCH | `/quests/{id}/skip` | Skip quest |
| DELETE | `/quests/{id}` | Delete instance |

### Drawer Items

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/drawer` | List all items |
| GET | `/drawer/status` | Get status summary |
| POST | `/drawer` | Create item |
| PUT | `/drawer/{id}` | Update item |
| PATCH | `/drawer/{id}/organize` | Mark organized |
| DELETE | `/drawer/{id}` | Delete item |

### User Preferences

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/prefs` | Get preferences |
| PUT | `/prefs` | Update preferences |

## Security Notes

1. **JWT Secret**: Generate a strong secret key for production:
   ```python
   import secrets
   print(secrets.token_hex(32))
   ```

2. **MongoDB IP Whitelist**: For PythonAnywhere, you need to whitelist `0.0.0.0/0` (any IP) in MongoDB Atlas Network Access since PythonAnywhere's outgoing IP can change.

3. **HTTPS**: PythonAnywhere provides free HTTPS for your subdomain.

## Flutter Integration

After deploying, update your Flutter app to use the API:

1. Add `http` or `dio` package to `pubspec.yaml`
2. Create an API client service
3. Update repositories to call API endpoints
4. Implement token storage and refresh logic

Example API client pattern is documented separately.


