#!/usr/bin/env python3
"""Scan Flutter frontend for likely missing form sanitization / validation.

This is a heuristic static scanner. It looks for:
  - TextField / TextFormField definitions without validators or input formatters
  - Controller `.text` reads sent to APIs / models without `.trim()`
  - Email / password / number-ish fields missing obvious format restrictions

The goal is triage, not proof. Review findings before acting on them.

Usage:
  python3 tools/form_sanitization_scan.py
  python3 tools/form_sanitization_scan.py frontend/lib
  python3 tools/form_sanitization_scan.py --json
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
# Files that are developer playgrounds / demos — not production UI.
SKIP_FILE_NAMES = {"ui_test_page.dart"}

FIELD_RE = re.compile(r"\b(TextField|TextFormField)\s*\(")
CONTROLLER_TEXT_RE = re.compile(r"\b([A-Za-z_][A-Za-z0-9_]*)\.text\b")


@dataclass
class Finding:
    category: str
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


def block(lines: list[str], start: int, before: int = 2, after: int = 18) -> str:
    lo = max(0, start - before)
    hi = min(len(lines), start + after)
    return "\n".join(lines[lo:hi])


def field_name_context(ctx: str) -> str:
    lower = ctx.lower()
    if "email" in lower:
        return "email"
    if "password" in lower:
        return "password"
    if any(token in lower for token in ("age", "count", "minutes", "hours", "number", "otp", "code", "pin")):
        return "numeric"
    if any(token in lower for token in ("phone", "mobile", "tel")):
        return "phone"
    return "generic"


def audit_text_fields(path: Path, lines: list[str], root: Path) -> list[Finding]:
    findings: list[Finding] = []
    for i, line in enumerate(lines):
        match = FIELD_RE.search(line)
        if not match:
            continue

        ctx = block(lines, i)
        lower = ctx.lower()
        kind = field_name_context(ctx)

        if "app_" in path.name or "ui_test_page.dart" in path.name:
            continue

        if "validator:" not in lower and "onvalidate" not in lower:
            findings.append(
                Finding(
                    category="field-validation",
                    severity="WARN",
                    path=rel(path, root),
                    line=i + 1,
                    code=snippet(lines, i),
                    note="Text input without nearby validator.",
                )
            )

        if kind in {"numeric", "phone"} and "inputformatters:" not in lower:
            findings.append(
                Finding(
                    category="field-formatting",
                    severity="WARN",
                    path=rel(path, root),
                    line=i + 1,
                    code=snippet(lines, i),
                    note=f"{kind.title()}-like field without nearby inputFormatters.",
                )
            )

        if kind == "email" and "trim()" not in lower and "appemailinput" not in lower:
            findings.append(
                Finding(
                    category="field-sanitization",
                    severity="WARN",
                    path=rel(path, root),
                    line=i + 1,
                    code=snippet(lines, i),
                    note="Email-like field without obvious trim/sanitization in local context.",
                )
            )
    return findings


def audit_controller_reads(path: Path, lines: list[str], root: Path) -> list[Finding]:
    findings: list[Finding] = []
    for i, line in enumerate(lines):
        if ".text" not in line:
            continue
        # Already safe / not an API submission read.
        if ".text.trim()" in line or ".text.toLowerCase()" in line:
            continue
        if ".text.isEmpty" in line or ".text.isNotEmpty" in line:
            continue
        if "TextEditingController(" in line:
            continue
        if line.lstrip().startswith("//"):
            continue
        # Assignments to a controller (e.g. _ctrl.text = ...) — not a read for submission.
        if re.search(r"\.text\s*=\s*", line):
            continue
        # Setting initialValue from a controller — internal widget wiring, not API submission.
        if "initialValue:" in line:
            continue
        # Copying to clipboard — passwords/tokens must NOT be trimmed; this is not an API call.
        if "ClipboardData(" in line:
            continue
        # Password controllers — passwords must never be trimmed (trimming changes credentials).
        lower_line = line.lower()
        if "password" in lower_line and "controller" in lower_line:
            continue

        lower = line.lower()
        if not any(
            token in lower
            for token in (
                "api.",
                "await api",
                "request(",
                "submit",
                "create",
                "update",
                "save",
                "payload",
                "body:",
                "jsonencode",
                "copywith(",
                ": _",
                "email:",
                "firstName".lower(),
                "lastName".lower(),
                "name:",
                "title:",
                "description:",
                "content:",
                "notes:",
                "message:",
                "signature",
            )
        ):
            continue

        for match in CONTROLLER_TEXT_RE.finditer(line):
            controller = match.group(1)
            findings.append(
                Finding(
                    category="controller-read",
                    severity="FAIL",
                    path=rel(path, root),
                    line=i + 1,
                    code=snippet(lines, i),
                    note=f"Controller read `{controller}.text` used without `.trim()`.",
                )
            )
    return findings


_SUBMIT_CALL_RE = re.compile(
    r"\b(_submit|_onSubmit|_handleSubmit|_onSave|_handleSave)\s*\(",
    re.IGNORECASE,
)

def audit_submission_blocks(path: Path, lines: list[str], root: Path) -> list[Finding]:
    findings: list[Finding] = []
    for i, line in enumerate(lines):
        # Only trigger on actual function *calls*, not callback references or variable names.
        # e.g. _submit(...) or _handleSubmit() — not `onSubmit: fn`, `_submitError`, `_isSubmitting`.
        if not _SUBMIT_CALL_RE.search(line):
            continue
        # Skip widget constructor parameter declarations (this.onSubmitted).
        if line.lstrip().startswith(("this.", "final ", "required ")):
            continue
        ctx = block(lines, i, before=0, after=28)
        # Skip if all controller reads in context are for passwords (must not be trimmed).
        if ".text" in ctx and "password" in ctx.lower():
            continue
        if ".text" in ctx and ".trim()" not in ctx and "validator:" not in ctx:
            findings.append(
                Finding(
                    category="submit-flow",
                    severity="WARN",
                    path=rel(path, root),
                    line=i + 1,
                    code=snippet(lines, i),
                    note="Submission flow uses controller text without obvious trim/validation nearby.",
                )
            )
    return findings


def dedupe(findings: list[Finding]) -> list[Finding]:
    seen: set[tuple[str, int, str, str]] = set()
    out: list[Finding] = []
    for finding in findings:
        key = (finding.path, finding.line, finding.category, finding.note)
        if key not in seen:
            seen.add(key)
            out.append(finding)
    return out


def scan_file(path: Path, root: Path) -> list[Finding]:
    try:
        content = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return []
    lines = content.splitlines()
    findings: list[Finding] = []
    findings.extend(audit_text_fields(path, lines, root))
    findings.extend(audit_controller_reads(path, lines, root))
    findings.extend(audit_submission_blocks(path, lines, root))
    return dedupe(findings)


def main() -> int:
    args = parse_args()
    root = Path(args.root)
    if not root.exists():
        raise SystemExit(f"Path does not exist: {root}")

    findings: list[Finding] = []
    for path in sorted(iter_dart_files(root)):
        findings.extend(scan_file(path, root))

    findings = sorted(findings, key=lambda item: (item.path, item.line, item.category))

    if args.json:
        print(json.dumps([asdict(finding) for finding in findings], indent=2))
        return 0

    if not findings:
        print("No likely missing form sanitization findings found.")
        return 0

    current_path = None
    for finding in findings:
        if finding.path != current_path:
            current_path = finding.path
            print(f"\n{finding.path}")
        print(f"  {finding.line}  [{finding.severity}] {finding.category}  {finding.note}")
        print(f"      {finding.code}")

    print(f"\nTotal findings: {len(findings)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
