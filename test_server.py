#!/usr/bin/env python3
"""
Simple test script to verify web server functionality
"""

import http.server
import socketserver
import os
import webbrowser
from pathlib import Path

# Get the web directory
WEB_DIR = Path(__file__).parent / "web"

class TestHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(WEB_DIR), **kwargs)
    
    def log_message(self, format, *args):
        print(f"[{self.log_date_time_string()}] {format % args}")

def main():
    PORT = 8080
    
    print(f"🔍 Testing web server...")
    print(f"📁 Web directory: {WEB_DIR}")
    print(f"📋 Files in web directory:")
    
    if WEB_DIR.exists():
        for file in WEB_DIR.iterdir():
            if file.is_file():
                print(f"   ✅ {file.name}")
            else:
                print(f"   📁 {file.name}/")
    else:
        print("   ❌ Web directory not found!")
        return
    
    print(f"\n🚀 Starting server on port {PORT}...")
    
    try:
        with socketserver.TCPServer(("", PORT), TestHTTPRequestHandler) as httpd:
            print(f"✅ Server started successfully!")
            print(f"🌐 Server running at: http://localhost:{PORT}")
            print(f"🔗 Test URLs:")
            print(f"   • Main page: http://localhost:{PORT}/")
            print(f"   • Firebase test: http://localhost:{PORT}/firebase_test.html")
            print(f"   • Super admin: http://localhost:{PORT}/super_admin_register.html")
            print(f"   • Simple test: http://localhost:{PORT}/test.html")
            print(f"\n⏹️  Press Ctrl+C to stop")
            print("-" * 50)
            
            # Open browser automatically
            webbrowser.open(f'http://localhost:{PORT}')
            
            httpd.serve_forever()
            
    except KeyboardInterrupt:
        print("\n\n🛑 Server stopped by user")
    except OSError as e:
        print(f"❌ Error starting server: {e}")
        if e.errno == 48:  # Address already in use
            print("💡 Try stopping other servers or use a different port")

if __name__ == "__main__":
    main()
