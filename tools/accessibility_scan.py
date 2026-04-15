#!/usr/bin/env python3
"""Scan Flutter frontend for likely WCAG A / AA accessibility misses.

This is a heuristic static scanner for Dart source. It does not prove
compliance; it highlights places worth reviewing.

Current checks:
  - WCAG 4.1.2: IconButton without tooltip or surrounding Tooltip
  - WCAG 2.1.1 / 4.1.2: GestureDetector used as interactive control without
    nearby Semantics / InkWell / MouseRegion handling
  - WCAG 1.1.1: Image.asset / SvgPicture without semantic label or explicit
    decorative exclusion
  - WCAG 3.3.2 / 4.1.2: TextField / TextFormField without visible label,
    hint, or semantics context
  - WCAG 1.3.1 / 2.4.6: heading-styled Text without Semantics(header: true)

Usage:
  python3 tools/accessibility_scan.py
  python3 tools/accessibility_scan.py frontend/lib
  python3 tools/accessibility_scan.py --json
"""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Iterable


DEFAULT_ROOT = Path("frontend/lib")
SKIP_DIR_NAMES = {".dart_tool", ".git", "build", ".idea", ".vscode", "l10n"}
SKIP_FILE_SUFFIXES = {".g.dart", ".freezed.dart", ".gr.dart", ".config.dart", ".mocks.dart"}
# Developer playground pages — not production UI, accessibility not enforced here.
SKIP_FILE_NAMES = {"ui_test_page.dart"}

HEADING_STYLE_PATTERNS = [
    r"AppTheme\.heading[1-4]",
    r"AppTheme\.displayLarge",
    r"AppTheme\.displayMedium",
    r"AppTheme\.displaySmall",
    r"textTheme\.displaySmall",
    r"textTheme\.displayMedium",
    r"textTheme\.displayLarge",
    r"textTheme\.headlineSmall",
    r"textTheme\.headlineMedium",
    r"textTheme\.headlineLarge",
]

HEADING_RE = re.compile("|".join(HEADING_STYLE_PATTERNS))
IMAGE_RE = re.compile(r"\b(?:Image\.asset|SvgPicture\.(?:asset|string|memory|network))\s*\(")


@dataclass
class Finding:
    criterion: str
    severity: str
    path: str
    line: int
    code: str
    note: str


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", nargs="?", default=str(DEFAULT_ROOT), help="Directory to scan.")
    parser.add_argument("--json", action="store_true", help="Emit JSON.")
    return parser.parse_args()


def should_skip_file(path: Path) -> bool:
    if any(part in SKIP_DIR_NAMES for part in path.parts):
        return True
    if path.name in SKIP_FILE_NAMES:
        return True
    return any(path.name.endswith(suffix) for suffix in SKIP_FILE_SUFFIXES)


def iter_dart_files(root: Path) -> Iterable[Path]:
    if root.is_file() and root.suffix == ".dart":
        if not should_skip_file(root):
            yield root
        return
    for path in root.rglob("*.dart"):
        if not should_skip_file(path):
            yield path


def rel(path: Path, root: Path) -> str:
    try:
        return str(path.relative_to(root.parent))
    except ValueError:
        return str(path)


def snippet(lines: list[str], index: int) -> str:
    return lines[index].strip()


def block(lines: list[str], start: int, before: int = 0, after: int = 12) -> str:
    lo = max(0, start - before)
    hi = min(len(lines), start + after)
    return "\n".join(lines[lo:hi])


def audit_headings(path: Path, lines: list[str], root: Path) -> list[Finding]:
    findings: list[Finding] = []
    for i, line in enumerate(lines):
        if not HEADING_RE.search(line):
            continue
        ctx = block(lines, i, before=5, after=5)
        if "Text(" not in ctx and "AppText(" not in ctx:
            continue
        if "AppText(" in ctx:
            continue
        if "header: true" in ctx:
            continue
        findings.append(
            Finding(
                criterion="1.3.1 / 2.4.6",
                severity="FAIL",
                path=rel(path, root),
                line=i + 1,
                code=snippet(lines, i),
                note="Heading-style text without Semantics(header: true).",
            )
        )
    return findings


def audit_icon_buttons(path: Path, lines: list[str], root: Path) -> list[Finding]:
    findings: list[Finding] = []
    for i, line in enumerate(lines):
        # Only match the IconButton constructor — not static methods like IconButton.styleFrom().
        if "IconButton(" not in line:
            continue
        ctx = block(lines, i, before=3, after=20)
        parent_ctx = block(lines, i, before=3, after=0)
        if "tooltip:" in ctx or "Tooltip(" in parent_ctx:
            continue
        if "ExcludeSemantics" in ctx:
            continue
        findings.append(
            Finding(
                criterion="4.1.2",
                severity="FAIL",
                path=rel(path, root),
                line=i + 1,
                code=snippet(lines, i),
                note="IconButton without tooltip or Tooltip wrapper.",
            )
        )
    return findings


def audit_gesture_detectors(path: Path, lines: list[str], root: Path) -> list[Finding]:
    findings: list[Finding] = []
    for i, line in enumerate(lines):
        if "GestureDetector(" not in line:
            continue
        ctx = block(lines, i, before=3, after=20)
        if not any(token in ctx for token in ("onTap:", "onDoubleTap:", "onLongPress:")):
            continue
        if any(token in ctx for token in ("Semantics(", "InkWell(", "InkResponse(", "FocusableActionDetector(")):
            continue
        findings.append(
            Finding(
                criterion="2.1.1 / 4.1.2",
                severity="FAIL",
                path=rel(path, root),
                line=i + 1,
                code=snippet(lines, i),
                note="Interactive GestureDetector without nearby semantics or keyboard-friendly control.",
            )
        )
    return findings


def audit_images(path: Path, lines: list[str], root: Path) -> list[Finding]:
    findings: list[Finding] = []
    for i, line in enumerate(lines):
        if not IMAGE_RE.search(line):
            continue
        ctx = block(lines, i, before=2, after=16)
        if any(
            token in ctx
            for token in (
                "semanticLabel:",
                "Semantics(",
                "ExcludeSemantics(",
                "excludeFromSemantics: true",
                "matchTextDirection:",
            )
        ):
            continue
        findings.append(
            Finding(
                criterion="1.1.1",
                severity="WARN",
                path=rel(path, root),
                line=i + 1,
                code=snippet(lines, i),
                note="Image/SVG missing semanticLabel or decorative exclusion.",
            )
        )
    return findings


def audit_text_fields(path: Path, lines: list[str], root: Path) -> list[Finding]:
    findings: list[Finding] = []
    for i, line in enumerate(lines):
        if "TextField(" not in line and "TextFormField(" not in line:
            continue
        ctx = block(lines, i, before=5, after=24)
        if any(
            token in ctx
            for token in (
                "labelText:",
                "hintText:",
                "helperText:",
                "semanticsLabel:",
                "Semantics(",
                "AppTextField(",
            )
        ):
            continue
        findings.append(
            Finding(
                criterion="3.3.2 / 4.1.2",
                severity="WARN",
                path=rel(path, root),
                line=i + 1,
                code=snippet(lines, i),
                note="Text input missing obvious label/hint/semantics context.",
            )
        )
    return findings


def scan_file(path: Path, root: Path) -> list[Finding]:
    try:
        content = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return []
    lines = content.splitlines()
    findings: list[Finding] = []
    findings.extend(audit_headings(path, lines, root))
    findings.extend(audit_icon_buttons(path, lines, root))
    findings.extend(audit_gesture_detectors(path, lines, root))
    findings.extend(audit_images(path, lines, root))
    findings.extend(audit_text_fields(path, lines, root))
    return findings


def main() -> int:
    args = parse_args()
    root = Path(args.root)
    if not root.exists():
        raise SystemExit(f"Path does not exist: {root}")

    findings: list[Finding] = []
    for path in sorted(iter_dart_files(root)):
        findings.extend(scan_file(path, root))

    if args.json:
        print(json.dumps([asdict(finding) for finding in findings], indent=2))
        return 0

    if not findings:
        print("No likely WCAG A/AA accessibility misses found.")
        return 0

    current_path = None
    for finding in findings:
        if finding.path != current_path:
            current_path = finding.path
            print(f"\n{finding.path}")
        print(f"  {finding.line}  [{finding.severity}] {finding.criterion}  {finding.note}")
        print(f"      {finding.code}")

    print(f"\nTotal findings: {len(findings)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
