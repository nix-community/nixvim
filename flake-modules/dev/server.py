import http.server

PORT = 8000


class UncachedHTTPHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()


with http.server.HTTPServer(("", PORT), UncachedHTTPHandler) as httpd:
    print(f"Serving documentation at http://localhost:{PORT}")
    httpd.serve_forever()
