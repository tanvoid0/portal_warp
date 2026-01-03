#!/bin/bash

# Portal Warp Development Script
# Runs both backend server and Flutter app

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Detect OS and set default Flutter platform
detect_platform() {
    case "$(uname -s)" in
        Linux*)
            echo "linux"
            ;;
        Darwin*)
            echo "macos"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "windows"
            ;;
        *)
            echo "windows"  # Default fallback
            ;;
    esac
}

# Find Python executable (prioritize Anaconda on Windows)
find_python() {
    # Check for Anaconda Python first (Windows)
    if [ -f "/c/ProgramData/anaconda3/python.exe" ]; then
        echo "/c/ProgramData/anaconda3/python.exe"
    elif [ -f "C:/ProgramData/anaconda3/python.exe" ]; then
        echo "C:/ProgramData/anaconda3/python.exe"
    elif command -v python3 &> /dev/null; then
        echo "python3"
    elif command -v python &> /dev/null; then
        echo "python"
    else
        echo "python"  # Fallback, will show error if not found
    fi
}

PLATFORM=${1:-$(detect_platform)}
PYTHON_CMD=$(find_python)
BACKEND_DIR="backend"
VENV_PATH="$BACKEND_DIR/venv"

echo -e "${GREEN}🚀 Starting Portal Warp Development Environment${NC}"
echo -e "${YELLOW}Platform: $PLATFORM${NC}"

# Function to cleanup on exit
cleanup() {
    echo -e "\n${YELLOW}🛑 Shutting down...${NC}"
    if [ ! -z "$BACKEND_PID" ]; then
        echo -e "${YELLOW}Stopping backend server (PID: $BACKEND_PID)${NC}"
        kill $BACKEND_PID 2>/dev/null || true
    fi
    exit 0
}

# Set up trap to cleanup on script exit
trap cleanup SIGINT SIGTERM EXIT

# Check if backend directory exists
if [ ! -d "$BACKEND_DIR" ]; then
    echo -e "${RED}❌ Backend directory not found!${NC}"
    exit 1
fi

# Start backend server
echo -e "${GREEN}📡 Starting backend server...${NC}"
cd "$BACKEND_DIR"

# Activate virtual environment if it exists
if [ -d "$VENV_PATH" ]; then
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows (Git Bash)
        source "$VENV_PATH/Scripts/activate"
    else
        # Linux/Mac
        source "$VENV_PATH/bin/activate"
    fi
    echo -e "${GREEN}✓ Virtual environment activated${NC}"
else
    echo -e "${YELLOW}⚠ Virtual environment not found. Running without venv.${NC}"
    echo -e "${YELLOW}  Consider creating one: python -m venv venv${NC}"
fi

# Start backend in background
echo -e "${GREEN}Using Python: $PYTHON_CMD${NC}"
$PYTHON_CMD run.py &
BACKEND_PID=$!
cd ..

# Wait a moment for backend to start
sleep 2

# Check if backend is running
if ! kill -0 $BACKEND_PID 2>/dev/null; then
    echo -e "${RED}❌ Backend server failed to start!${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Backend server running (PID: $BACKEND_PID)${NC}"
echo -e "${GREEN}  API available at: http://localhost:8000${NC}"
echo -e "${GREEN}  Docs available at: http://localhost:8000/docs${NC}"

# Start Flutter app
echo -e "${GREEN}📱 Starting Flutter app on $PLATFORM...${NC}"
flutter run -d $PLATFORM

