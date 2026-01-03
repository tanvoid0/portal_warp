"""
WSGI entry point for PythonAnywhere deployment.

PythonAnywhere requires a WSGI application. This file provides the entry point.

In PythonAnywhere WSGI configuration file, use:
    
    import sys
    path = '/home/YOUR_USERNAME/portal_warp/backend'
    if path not in sys.path:
        sys.path.append(path)
    
    from wsgi import app as application

"""

from app.main import app

# For ASGI-to-WSGI compatibility on PythonAnywhere
# PythonAnywhere natively supports ASGI now with their new system
# but this provides backward compatibility

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)


