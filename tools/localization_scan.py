#!/usr/bin/env python3
"""Scan Dart files for likely hard-coded UI text that should be localized.

The scanner is heuristic by design. It looks for string literals in `.dart`
files and reports literals that resemble user-facing text while skipping common
false positives such as imports, asset paths, interpolation, and obvious route
/ enum / constant identifiers.

Usage:
  python3 tools/localization_scan.py
  python3 tools/localization_scan.py frontend/lib
  python3 tools/localization_scan.py --json
"""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Iterable


DEFAULT_ROOT = Path("frontend/lib")
SKIP_DIR_NAMES = {
    ".dart_tool",
    ".git",
    "build",
    ".idea",
    ".vscode",
    "l10n",       # generated & source ARB/Dart localisation files — not production UI code
    "generated",  # any generated sub-directory
}
SKIP_FILE_SUFFIXES = {
    ".g.dart",
    ".freezed.dart",
    ".gr.dart",
    ".config.dart",
    ".mocks.dart",
}
# Infrastructure / routing files that use string identifiers, not display text.
# Also developer playground pages.
SKIP_FILE_NAMES = {
    "go_router.dart",
    "navigation.dart",
    "mobile_auth_interceptor.dart",
    "app_routes.dart",
    "app_strings.dart",        # string-constants file — not UI widgets, strings defined here intentionally
    "ui_test_page.dart",       # developer playground, not production UI
    "theme.dart",              # theme configuration names (Classic Cream, Modern, etc.) — not localised by design
    "database_viewer_page.dart",  # admin DB tool: shows raw table names (AccountData, AuditEvent …) as identifiers
}
# Known brand names and product-specific proper nouns that are never localised.
BRAND_NAMES: set[str] = {"HealthBank"}
# HTTP header field names — never user-facing display text.
HTTP_HEADER_RE = re.compile(r"^[A-Za-z][A-Za-z0-9]*(?:-[A-Za-z0-9]+)+$")

LINE_STRING_RE = re.compile(
    r"""
    (?P<prefix>\br\b)?                  # raw string prefix
    (?P<quote>'|")                      # opening quote
    (?P<body>(?:\\.|[^\\'"])*?)         # body
    (?P=quote)                          # closing quote
    """,
    re.VERBOSE,
)

WORD_RE = re.compile(r"[A-Za-z]{2,}")
PATHISH_RE = re.compile(r"^[a-zA-Z0-9_./:#?=&%-]+$")
IDENTIFIERISH_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
CAMEL_OR_SNAKE_RE = re.compile(r"^[a-z][A-Za-z0-9_]*$")
KEBAB_RE = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)+$")
DATE_FORMAT_RE = re.compile(r"^[dMyHhmsaEzZ:/,\- ]+$")


@dataclass
class Finding:
    path: str
    line: int
    column: int
    text: str
    context: str


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "root",
        nargs="?",
        default=str(DEFAULT_ROOT),
        help="Directory to scan. Defaults to frontend/lib.",
    )
    parser.add_argument("--json", action="store_true", help="Emit JSON output.")
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


def strip_comment_lines(line: str) -> str:
    return line.split("//", 1)[0]


def looks_like_user_text(text: str, context: str) -> bool:
    stripped = text.strip()
    if not stripped:
        return False

    if "\\n" in stripped or "\n" in stripped:
        normalized = " ".join(part.strip() for part in stripped.splitlines() if part.strip())
        if normalized:
            stripped = normalized

    lower_context = context.lower()
    lower_text = stripped.lower()

    if "$" in stripped:
        return False
    if len(stripped) < 2:
        return False
    if stripped in {"true", "false", "null"}:
        return False
    if stripped.startswith(("http://", "https://", "asset:", "package:")):
        return False
    if stripped.startswith(("/", "#", "assets/", "lib/", "frontend/")):
        return False
    if stripped.endswith((".png", ".jpg", ".jpeg", ".svg", ".json", ".arb", ".dart")):
        return False
    if stripped.endswith((".csv", ".txt", ".md")):
        return False
    if PATHISH_RE.fullmatch(stripped) and "/" in stripped:
        return False
    if IDENTIFIERISH_RE.fullmatch(stripped) and CAMEL_OR_SNAKE_RE.fullmatch(stripped):
        return False
    if KEBAB_RE.fullmatch(stripped):
        return False
    if DATE_FORMAT_RE.fullmatch(stripped):
        return False
    if re.fullmatch(r"[A-Z0-9_ -]+", stripped):
        return False
    if re.fullmatch(r"[-+]?[\d\s.,:%]+", stripped):
        return False
    if lower_text in {"en", "fr", "es", "api", "id"}:
        return False
    # Brand / product names that are intentionally not localised.
    if stripped in BRAND_NAMES:
        return False
    # HTTP header field names (e.g. 'Content-Type', 'X-Client-Type', 'Authorization').
    if HTTP_HEADER_RE.fullmatch(stripped):
        return False
    # Strings that look like HTTP verbs or protocol tokens in header-related contexts.
    if any(token in lower_context for token in ("headers[", "header:", "\"authorization\"", "'authorization'")):
        return False
    # Single-word HTTP standard header names (e.g. 'Accept', 'Authorization') — no hyphens needed.
    if stripped in {"Accept", "Authorization", "Connection", "Host", "Origin", "Referer",
                    "Cookie", "Bearer", "application/json", "application/x-www-form-urlencoded"}:
        return False

    # Ignore obvious non-UI contexts.
    if any(
        token in lower_context
        for token in (
            "import ",
            "export ",
            "part ",
            "dart:",
            "package:",
            "debugprint",
            "log(",
            "logger.",
            "print(",
            "@pragma",
            "semanticslabel",
            "test(",
            "group(",
        )
    ):
        return False

    if any(
        token in lower_context
        for token in (
            "key(",
            "icondata(",
            "route",
            "path:",
            "name:",
            "enum",
            "extension",
            "typedef",
        )
    ) and WORD_RE.search(stripped) is None:
        return False

    words = WORD_RE.findall(stripped)
    if not words:
        return False

    # Bias toward likely visible copy.
    if "text(" in lower_context or "tooltip(" in lower_context or "label" in lower_context:
        return True
    if "title" in lower_context or "hint" in lower_context or "snackbar" in lower_context:
        return True
    if "button(" in lower_context or "appbar(" in lower_context or "dialog(" in lower_context:
        return True

    # General fallback: sentence-like text with spaces or punctuation.
    if len(words) >= 2:
        return True
    if any(ch in stripped for ch in (" ", "!", "?", ".", ",", ":")):
        return True
    if stripped[:1].isupper() and len(stripped) > 3:
        return True

    return False


def scan_file(path: Path) -> list[Finding]:
    try:
        content = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return []

    findings: list[Finding] = []
    lines = content.splitlines()
    in_multiline = False
    multiline_delim = ""

    for line_number, raw_line in enumerate(lines, start=1):
        line = raw_line
        stripped = line.strip()

        if not in_multiline and ("'''" in stripped or '"""' in stripped):
            triple_single = stripped.count("'''")
            triple_double = stripped.count('"""')
            if triple_single % 2 == 1:
                in_multiline = True
                multiline_delim = "'''"
            elif triple_double % 2 == 1:
                in_multiline = True
                multiline_delim = '"""'
            continue

        if in_multiline:
            if multiline_delim and multiline_delim in line:
                in_multiline = False
                multiline_delim = ""
            continue

        context = strip_comment_lines(line).strip()
        for match in LINE_STRING_RE.finditer(context):
            literal = match.group("body")
            if looks_like_user_text(literal, context):
                findings.append(
                    Finding(
                        path=str(path),
                        line=line_number,
                        column=match.start() + 1,
                        text=" ".join(literal.strip().split()),
                        context=context,
                    )
                )
    return findings


def main() -> int:
    args = parse_args()
    root = Path(args.root)
    if not root.exists():
        raise SystemExit(f"Path does not exist: {root}")

    all_findings: list[Finding] = []
    for path in sorted(iter_dart_files(root)):
        all_findings.extend(scan_file(path))

    if args.json:
        print(json.dumps([asdict(item) for item in all_findings], indent=2))
        return 0

    if not all_findings:
        print("No likely hard-coded localization misses found.")
        return 0

    current_path = None
    for finding in all_findings:
        if finding.path != current_path:
            current_path = finding.path
            print(f"\n{current_path}")
        print(f"  {finding.line}:{finding.column}  {finding.text}")
    print(f"\nTotal findings: {len(all_findings)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
