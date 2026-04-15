#!/usr/bin/env python3
"""Run a Flutter render/overflow smoke scan across a viewport matrix.

This wraps `frontend/test/render_overflow_smoke_test.dart`, which pumps app
routes under multiple viewport sizes and fails on common rendering issues like:
  - RenderFlex overflowed
  - RenderViewport overflowed
  - unbounded viewport constraints
  - "was not laid out"
  - asset load failures during render

Usage:
  python3 tools/flutter_render_scan.py
  python3 tools/flutter_render_scan.py --route /contact --route /login
  python3 tools/flutter_render_scan.py --viewport 320x568 --viewport 1440x900
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
from dataclasses import dataclass, asdict
from datetime import datetime
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
FRONTEND = ROOT / "frontend"
TEST_FILE = "test/render_overflow_smoke_test.dart"
ARTIFACT_ROOT = ROOT / "tools" / "render-scan" / "artifacts"


@dataclass
class RouteScenario:
    name: str
    route: str
    authenticated: bool
    role: str | None = None


@dataclass
class ViewportScenario:
    name: str
    width: int
    height: int


DEFAULT_VIEWPORTS = [
    ViewportScenario("mobile_small", 320, 568),
    ViewportScenario("mobile_medium", 390, 844),
    ViewportScenario("tablet_portrait", 768, 1024),
    ViewportScenario("tablet_landscape", 1024, 768),
    ViewportScenario("desktop", 1440, 900),
]

DEFAULT_ROUTES = [
    RouteScenario("home", "/", False),
    RouteScenario("login", "/login", False),
    RouteScenario("forgot_password", "/forgot-password", False),
    RouteScenario("request_account", "/request-account", False),
    RouteScenario("about", "/about", False),
    RouteScenario("contact", "/contact", False),
    RouteScenario("help", "/help", False),
    RouteScenario("terms", "/terms-of-service", False),
    RouteScenario("privacy", "/privacy-policy", False),
    RouteScenario("participant_dashboard", "/participant/dashboard", True, "participant"),
    RouteScenario("participant_surveys", "/participant/surveys", True, "participant"),
    RouteScenario("participant_results", "/participant/results", True, "participant"),
    RouteScenario("participant_tasks", "/participant/tasks", True, "participant"),
    RouteScenario("participant_health_tracking", "/participant/health-tracking", True, "participant"),
    RouteScenario("settings", "/settings", True, "participant"),
    RouteScenario("profile", "/profile", True, "participant"),
    RouteScenario("researcher_dashboard", "/researcher/dashboard", True, "researcher"),
    RouteScenario("researcher_surveys", "/surveys", True, "researcher"),
    RouteScenario("researcher_templates", "/templates", True, "researcher"),
    RouteScenario("researcher_questions", "/questions", True, "researcher"),
    RouteScenario("researcher_data", "/researcher/data", True, "researcher"),
    RouteScenario("researcher_health_tracking", "/researcher/health-tracking", True, "researcher"),
    RouteScenario("hcp_dashboard", "/hcp/dashboard", True, "hcp"),
    RouteScenario("hcp_clients", "/hcp/clients", True, "hcp"),
    RouteScenario("hcp_reports", "/hcp/reports", True, "hcp"),
    RouteScenario("admin_dashboard", "/admin", True, "admin"),
    RouteScenario("admin_users", "/admin/users", True, "admin"),
    RouteScenario("admin_database", "/admin/database", True, "admin"),
    RouteScenario("admin_messages", "/admin/messages", True, "admin"),
    RouteScenario("admin_deletion_queue", "/admin/deletion-queue", True, "admin"),
    RouteScenario("admin_logs", "/admin/logs", True, "admin"),
    RouteScenario("admin_ui_test", "/admin/ui-test", True, "admin"),
    RouteScenario("admin_nav_hub", "/admin/nav-hub", True, "admin"),
    RouteScenario("admin_settings", "/admin/settings", True, "admin"),
    RouteScenario("admin_health_tracking", "/admin/health-tracking", True, "admin"),
    RouteScenario("messages_inbox", "/messages", True, "participant"),
    RouteScenario("messages_new", "/messages/new", True, "participant"),
    RouteScenario("messages_friends", "/messages/friends", True, "participant"),
]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--route",
        action="append",
        help="Limit the scan to specific routes. May be passed multiple times.",
    )
    parser.add_argument(
        "--viewport",
        action="append",
        help="Additional or replacement viewport in WIDTHxHEIGHT format.",
    )
    parser.add_argument(
        "--output-dir",
        help="Artifact directory. Defaults to tools/render-scan/artifacts/<timestamp>.",
    )
    parser.add_argument(
        "--keep-going",
        action="store_true",
        help="Return success even when the Flutter test reports failures.",
    )
    return parser.parse_args()


def parse_viewport(raw: str, index: int) -> ViewportScenario:
    try:
        width_text, height_text = raw.lower().split("x", 1)
        width = int(width_text)
        height = int(height_text)
    except Exception as exc:  # noqa: BLE001
        raise SystemExit(f"Invalid viewport '{raw}'. Expected WIDTHxHEIGHT.") from exc
    return ViewportScenario(name=f"custom_{index}_{width}x{height}", width=width, height=height)


def selected_routes(route_filters: list[str] | None) -> list[RouteScenario]:
    if not route_filters:
        return DEFAULT_ROUTES
    allowed = set(route_filters)
    return [route for route in DEFAULT_ROUTES if route.route in allowed]


def selected_viewports(raw_viewports: list[str] | None) -> list[ViewportScenario]:
    if not raw_viewports:
        return DEFAULT_VIEWPORTS
    return [parse_viewport(raw, index) for index, raw in enumerate(raw_viewports, start=1)]


def read_results(output_file: Path) -> list[dict]:
    if not output_file.exists():
        return []
    rows = []
    for line in output_file.read_text(encoding="utf-8").splitlines():
        if line.strip():
            rows.append(json.loads(line))
    return rows


def print_summary(results: list[dict]) -> None:
    failures = [row for row in results if row.get("status") == "fail"]
    print(f"Scanned {len(results)} route/viewport combinations.")
    if not failures:
        print("No render overflow issues detected.")
        return
    print(f"Failures: {len(failures)}")
    for row in failures:
        print(
            f"- {row['scenario']} @ {row['viewport']} ({row['route']}): "
            f"{'; '.join(row.get('render_errors', []))}"
        )


def main() -> int:
    args = parse_args()
    routes = selected_routes(args.route)
    viewports = selected_viewports(args.viewport)
    if not routes:
        raise SystemExit("No routes selected.")

    artifact_dir = (
        Path(args.output_dir)
        if args.output_dir
        else ARTIFACT_ROOT / datetime.now().strftime("%Y%m%d-%H%M%S")
    )
    artifact_dir.mkdir(parents=True, exist_ok=True)
    output_file = artifact_dir / "render_results.jsonl"
    if output_file.exists():
        output_file.unlink()

    env = os.environ.copy()
    env["HB_RENDER_SCENARIOS"] = json.dumps([asdict(route) for route in routes])
    env["HB_RENDER_VIEWPORTS"] = json.dumps([asdict(viewport) for viewport in viewports])
    env["HB_RENDER_OUTPUT"] = str(output_file)

    cmd = ["flutter", "test", TEST_FILE, "-r", "expanded"]
    completed = subprocess.run(cmd, cwd=FRONTEND, env=env, check=False)

    results = read_results(output_file)
    print_summary(results)
    print(f"Artifacts: {artifact_dir}")

    if completed.returncode != 0 and not args.keep_going:
      return completed.returncode
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
