#!/usr/bin/env python3
"""
Simple HTTP server for serving Wine Tory web files
This helps avoid CORS issues when testing Firebase locally
"""

import http.server
import socketserver
import os
import sys
from pathlib import Path

# Get the project root directory
PROJECT_ROOT = Path(__file__).parent
WEB_DIR = PROJECT_ROOT / "web"

class CustomHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=WEB_DIR, **kwargs)
    
    def end_headers(self):
        # Add CORS headers to allow Firebase to work
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        super().end_headers()
    
    def do_OPTIONS(self):
        # Handle preflight requests
        self.send_response(200)
        self.end_headers()

def main():
    PORT = 8080
    
    # Check if web directory exists
    if not WEB_DIR.exists():
        print(f"Error: Web directory not found at {WEB_DIR}")
        sys.exit(1)
    
    # Change to web directory
    os.chdir(WEB_DIR)
    
    try:
        with socketserver.TCPServer(("", PORT), CustomHTTPRequestHandler) as httpd:
            print(f"🚀 Wine Tory Web Server running at:")
            print(f"   http://localhost:{PORT}")
            print(f"   http://127.0.0.1:{PORT}")
            print(f"\n📁 Serving files from: {WEB_DIR}")
            print(f"\n🔗 Available pages:")
            print(f"   • Firebase Test: http://localhost:{PORT}/firebase_test.html")
            print(f"   • Super Admin Register: http://localhost:{PORT}/super_admin_register.html")
            print(f"\n⏹️  Press Ctrl+C to stop the server")
            print("-" * 50)
            
            httpd.serve_forever()
            
    except KeyboardInterrupt:
        print("\n\n🛑 Server stopped by user")
    except OSError as e:
        if e.errno == 48:  # Address already in use
            print(f"❌ Port {PORT} is already in use. Try a different port or stop the other server.")
        else:
            print(f"❌ Error starting server: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
