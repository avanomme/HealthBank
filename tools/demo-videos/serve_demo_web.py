#!/usr/bin/env python3

from __future__ import annotations

import argparse
import http.server
import io
import socketserver
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path


class DemoWebHandler(http.server.SimpleHTTPRequestHandler):
    backend_base = "http://127.0.0.1:8000"
    static_root = Path.cwd()

    def translate_path(self, path: str) -> str:
        parsed = urllib.parse.urlparse(path)
        rel_path = parsed.path.lstrip("/")
        candidate = (self.static_root / rel_path).resolve()
        try:
            candidate.relative_to(self.static_root.resolve())
        except ValueError:
            return str(self.static_root)
        return str(candidate)

    def send_head(self):
        parsed = urllib.parse.urlparse(self.path)
        if not parsed.path.startswith("/api/"):
            candidate = (self.static_root / parsed.path.lstrip("/")).resolve()
            if parsed.path not in {"", "/"} and not candidate.exists():
                self.path = "/index.html"
        return super().send_head()

    def end_headers(self) -> None:
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def do_GET(self) -> None:
        if self.path.startswith("/api/"):
            self._proxy()
            return
        super().do_GET()

    def do_POST(self) -> None:
        if self.path.startswith("/api/"):
            self._proxy()
            return
        self.send_error(405, "Method not allowed")

    def do_PUT(self) -> None:
        if self.path.startswith("/api/"):
            self._proxy()
            return
        self.send_error(405, "Method not allowed")

    def do_PATCH(self) -> None:
        if self.path.startswith("/api/"):
            self._proxy()
            return
        self.send_error(405, "Method not allowed")

    def do_DELETE(self) -> None:
        if self.path.startswith("/api/"):
            self._proxy()
            return
        self.send_error(405, "Method not allowed")

    def _proxy(self) -> None:
        target = f"{self.backend_base}{self.path}"
        length = int(self.headers.get("Content-Length", "0"))
        body = self.rfile.read(length) if length else None

        headers = {
            key: value
            for key, value in self.headers.items()
            if key.lower() not in {"host", "content-length", "connection"}
        }

        request = urllib.request.Request(
            target,
            data=body,
            headers=headers,
            method=self.command,
        )

        try:
            with urllib.request.urlopen(request) as response:
                payload = response.read()
                self.send_response(response.status)
                for key, value in response.headers.items():
                    if key.lower() in {"transfer-encoding", "connection", "content-length"}:
                        continue
                    self.send_header(key, value)
                self.send_header("Content-Length", str(len(payload)))
                self.end_headers()
                self.wfile.write(payload)
        except urllib.error.HTTPError as error:
            payload = error.read()
            self.send_response(error.code)
            for key, value in error.headers.items():
                if key.lower() in {"transfer-encoding", "connection", "content-length"}:
                    continue
                self.send_header(key, value)
            self.send_header("Content-Length", str(len(payload)))
            self.end_headers()
            self.wfile.write(payload)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=62582)
    parser.add_argument(
        "--root",
        type=Path,
        default=Path(__file__).resolve().parents[2] / "frontend" / "build" / "web",
    )
    parser.add_argument("--backend", default="http://127.0.0.1:8000")
    args = parser.parse_args()

    DemoWebHandler.static_root = args.root.resolve()
    DemoWebHandler.backend_base = args.backend.rstrip("/")

    class ThreadingHTTPServer(socketserver.ThreadingMixIn, http.server.HTTPServer):
        daemon_threads = True

    with ThreadingHTTPServer(("0.0.0.0", args.port), DemoWebHandler) as server:
        print(f"Serving {DemoWebHandler.static_root} on http://localhost:{args.port}")
        print(f"Proxying /api/* to {DemoWebHandler.backend_base}")
        server.serve_forever()


if __name__ == "__main__":
    main()
