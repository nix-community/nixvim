from http.server import HTTPServer, SimpleHTTPRequestHandler
from subprocess import call

PORT = 8000
URL = f"http://localhost:{PORT}"


class AutoBrowseHTTPServer(HTTPServer):
    def server_activate(self):
        HTTPServer.server_activate(self)
        print(f"Serving documentation at {URL}")
        call(["xdg-open", URL])


class UncachedHTTPHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()


if __name__ == "__main__":
    with AutoBrowseHTTPServer(("", PORT), UncachedHTTPHandler) as httpd:
        httpd.serve_forever()
