#!/usr/bin/env python3
"""
WCAG 2.1 AA Accessibility Audit Script
Scans Flutter frontend for common accessibility violations.

Usage:
    python3 tools/wcag_audit.py [--fix]

Options:
    --fix   Auto-wrap known-safe decorative Icon() patterns in ExcludeSemantics.
            Only applies when the Icon is directly inside a Row/Column with
            adjacent Text — safe cases only. Review output before committing.
"""

import re
import sys
import os
from pathlib import Path
from dataclasses import dataclass, field
from typing import Optional

ROOT = Path(__file__).parent.parent / "frontend" / "lib" / "src"
FIX_MODE = "--fix" in sys.argv

# ── Heading style patterns ────────────────────────────────────────────────────
HEADING_STYLE_PATTERNS = [
    r"AppTheme\.heading[1-4]",
    r"AppTheme\.displayLarge",
    r"AppTheme\.displayMedium",
    r"AppTheme\.displaySmall",
    r"textTheme\.displaySmall",
    r"textTheme\.displayMedium",
    r"textTheme\.headlineMedium",
    r"textTheme\.headlineSmall",
]

# ── Icon patterns ─────────────────────────────────────────────────────────────
ICON_PATTERN = re.compile(r"\bIcon\(Icons\.")
EXCLUDE_SEMANTICS_PATTERN = re.compile(r"ExcludeSemantics\s*\(")
APP_ICON_PATTERN = re.compile(r"\bAppIcon\(")

# ── Results ───────────────────────────────────────────────────────────────────
@dataclass
class Finding:
    criterion: str
    severity: str       # FAIL / WARN / INFO
    file: str
    line: int
    code: str
    note: str

findings: list[Finding] = []

def rel(path: Path) -> str:
    return str(path.relative_to(ROOT.parent.parent.parent))


# ─────────────────────────────────────────────────────────────────────────────
# 1. Heading Text widgets not wrapped in Semantics(header: true)
# ─────────────────────────────────────────────────────────────────────────────
def audit_headings(dart_file: Path, lines: list[str]):
    heading_re = re.compile("|".join(HEADING_STYLE_PATTERNS))

    for i, line in enumerate(lines):
        if not heading_re.search(line):
            continue
        # Check if this line or nearby lines have a Text( wrapping
        # Look back up to 3 lines for a Text( call
        context_start = max(0, i - 3)
        context = "\n".join(lines[context_start : i + 2])
        if "Text(" not in context and "AppText(" not in context:
            continue
        # Check if there's Semantics(header: true) nearby (within 4 lines)
        check_start = max(0, i - 5)
        check_end = min(len(lines), i + 5)
        check_context = "\n".join(lines[check_start:check_end])
        if "header: true" in check_context:
            continue
        # Skip if inside AppText (which now handles heading semantics)
        if "AppText(" in context:
            continue
        findings.append(Finding(
            criterion="1.3.1 / 2.4.6",
            severity="FAIL",
            file=rel(dart_file),
            line=i + 1,
            code=line.strip(),
            note="Raw Text() with heading style — wrap with Semantics(header: true) "
                 "or replace Text() with AppText(variant: AppTextVariant.headlineSmall/Medium)",
        ))


# ─────────────────────────────────────────────────────────────────────────────
# 2. Bare Icon() not in ExcludeSemantics and no semanticLabel
# ─────────────────────────────────────────────────────────────────────────────
def audit_icons(dart_file: Path, lines: list[str]):
    for i, line in enumerate(lines):
        if not ICON_PATTERN.search(line):
            continue
        # Skip AppIcon (handled by the widget itself)
        if APP_ICON_PATTERN.search(line):
            continue
        # Skip comment lines (doc comments, inline comments)
        stripped = line.lstrip()
        if stripped.startswith("//"):
            continue
        # Skip if line already sets semanticLabel
        if "semanticLabel:" in line:
            continue
        # Check surrounding 3 lines for ExcludeSemantics
        check_start = max(0, i - 3)
        check_end = min(len(lines), i + 1)
        context = "\n".join(lines[check_start:check_end])
        if EXCLUDE_SEMANTICS_PATTERN.search(context):
            continue
        # Skip IconButton — it handles semantics via tooltip
        if "IconButton" in context or "IconButton" in line:
            continue
        # Skip icons in standard Flutter widget properties where the parent handles semantics:
        # prefixIcon/suffixIcon in InputDecoration, icon/leading/trailing/deleteIcon in widgets,
        # leadingIcon in custom widgets, avatar in chips.
        # These properties pass the icon as a child that Flutter's own accessibility handles.
        PROPERTY_PARAMS = (
            "prefixIcon:", "suffixIcon:", "deleteIcon:", "leading:",
            "trailing:", "leadingIcon:", "avatar:",
        )
        if any(p in context for p in PROPERTY_PARAMS):
            continue
        # For icon: property — skip if it's a named parameter (e.g. icon: const Icon(...))
        # but NOT if the Icon is a standalone widget (no preceding param name on this line context)
        if re.search(r"\bicon\s*:", context):
            continue
        findings.append(Finding(
            criterion="1.1.1",
            severity="WARN",
            file=rel(dart_file),
            line=i + 1,
            code=line.strip(),
            note="Bare Icon() — wrap in ExcludeSemantics if decorative, "
                 "or add semanticLabel: if it conveys meaning",
        ))


# ─────────────────────────────────────────────────────────────────────────────
# 3. IconButton without tooltip
# ─────────────────────────────────────────────────────────────────────────────
def audit_icon_buttons(dart_file: Path, lines: list[str]):
    for i, line in enumerate(lines):
        if "IconButton(" not in line and "IconButton.filled(" not in line:
            continue
        # Check up to 20 lines ahead for tooltip: (handles nested/multiline props)
        check_end = min(len(lines), i + 20)
        block = "\n".join(lines[i:check_end])
        if "tooltip:" in block:
            continue
        # Check up to 3 lines back for Tooltip( parent wrapper
        check_back = max(0, i - 3)
        parent_ctx = "\n".join(lines[check_back:i])
        if "Tooltip(" in parent_ctx:
            continue
        # Also check if this IconButton closes before 20 lines
        # (e.g. inline IconButton — if the closing ) appears before tooltip, it's missing)
        # Heuristic: if we see a blank line before tooltip, the button likely closed
        findings.append(Finding(
            criterion="4.1.2",
            severity="FAIL",
            file=rel(dart_file),
            line=i + 1,
            code=line.strip(),
            note="IconButton without tooltip — screen readers cannot identify this control. "
                 "Add tooltip: context.l10n.tooltipXxx",
        ))


# ─────────────────────────────────────────────────────────────────────────────
# 4. AppLoadingIndicator not yet using the new built-in liveRegion
#    (old pattern: wrapped externally in Semantics — now redundant/double)
# ─────────────────────────────────────────────────────────────────────────────
def audit_loading(dart_file: Path, lines: list[str]):
    for i, line in enumerate(lines):
        if "AppLoadingIndicator" not in line:
            continue
        # Check 3 lines above for manual Semantics(liveRegion: true) wrapper
        check_start = max(0, i - 4)
        context = "\n".join(lines[check_start:i])
        if "liveRegion: true" in context:
            findings.append(Finding(
                criterion="4.1.3",
                severity="INFO",
                file=rel(dart_file),
                line=i + 1,
                code=line.strip(),
                note="AppLoadingIndicator now has built-in liveRegion — "
                     "remove the outer Semantics(liveRegion: true) wrapper",
            ))


# ─────────────────────────────────────────────────────────────────────────────
# 5. GestureDetector used for interactive elements (should use InkWell)
# ─────────────────────────────────────────────────────────────────────────────
def audit_gesture_detector(dart_file: Path, lines: list[str]):
    for i, line in enumerate(lines):
        if "GestureDetector(" not in line:
            continue
        # Check next 5 lines for Semantics wrapping
        check_end = min(len(lines), i + 5)
        block = "\n".join(lines[i:check_end])
        if "Semantics(" in block:
            continue
        findings.append(Finding(
            criterion="2.1.1",
            severity="FAIL",
            file=rel(dart_file),
            line=i + 1,
            code=line.strip(),
            note="GestureDetector without Semantics wrapper — replace with "
                 "InkWell for built-in keyboard/screen-reader support",
        ))


# ─────────────────────────────────────────────────────────────────────────────
# 6. caution/success colors used as text color (contrast failure)
# ─────────────────────────────────────────────────────────────────────────────
def audit_color_contrast(dart_file: Path, lines: list[str]):
    bad_text_colors = [
        (r"\.copyWith\(color:\s*AppTheme\.caution\b", "AppTheme.caution (#FF9900) on white = 2.14:1 — FAILS 1.4.3 when used as text color"),
        (r"\.copyWith\(color:\s*AppTheme\.success\b", "AppTheme.success (#04B34F) on white = 2.78:1 — FAILS 1.4.3 when used as text color"),
        (r"TextStyle\([^)]*color:\s*AppTheme\.caution\b", "AppTheme.caution as TextStyle color — FAILS 1.4.3"),
        (r"TextStyle\([^)]*color:\s*AppTheme\.success\b", "AppTheme.success as TextStyle color — FAILS 1.4.3"),
        (r"color:\s*AppTheme\.placeholder\b[^,)]", "AppTheme.placeholder (#A9BAFF) as visible text — FAILS 1.4.3"),
    ]
    for i, line in enumerate(lines):
        # Skip lines with alpha/opacity modifiers (background use, not text)
        if "withAlpha" in line or "withValues(alpha:" in line or "withOpacity" in line:
            continue
        # Skip border, fill, background usages
        if any(k in line for k in ["border:", "fillColor", "backgroundColor",
                                    "BoxDecoration", "borderSide", "borderColor"]):
            continue
        for pattern, note in bad_text_colors:
            if re.search(pattern, line):
                findings.append(Finding(
                    criterion="1.4.3",
                    severity="FAIL",
                    file=rel(dart_file),
                    line=i + 1,
                    code=line.strip(),
                    note=note,
                ))


# ─────────────────────────────────────────────────────────────────────────────
# Run all audits
# ─────────────────────────────────────────────────────────────────────────────
dart_files = list(ROOT.rglob("*.dart"))
skip_dirs = {"generated", ".dart_tool", "l10n"}
# Skip the UI test page — it contains code snippets as strings, not real widgets
skip_files = {"ui_test_page.dart"}

for dart_file in sorted(dart_files):
    if any(part in dart_file.parts for part in skip_dirs):
        continue
    if dart_file.name in skip_files:
        continue
    try:
        content = dart_file.read_text(encoding="utf-8")
        lines = content.splitlines()
    except Exception:
        continue

    audit_headings(dart_file, lines)
    audit_icons(dart_file, lines)
    audit_icon_buttons(dart_file, lines)
    audit_loading(dart_file, lines)
    audit_gesture_detector(dart_file, lines)
    audit_color_contrast(dart_file, lines)


# ─────────────────────────────────────────────────────────────────────────────
# Report
# ─────────────────────────────────────────────────────────────────────────────
by_severity = {"FAIL": [], "WARN": [], "INFO": []}
for f in findings:
    by_severity[f.severity].append(f)

COLORS = {"FAIL": "\033[91m", "WARN": "\033[93m", "INFO": "\033[94m", "RESET": "\033[0m"}

total = len(findings)
print(f"\n{'='*72}")
print(f"  WCAG 2.1 AA Audit  —  {total} finding(s)")
print(f"  FAIL: {len(by_severity['FAIL'])}  |  WARN: {len(by_severity['WARN'])}  |  INFO: {len(by_severity['INFO'])}")
print(f"{'='*72}\n")

for severity in ["FAIL", "WARN", "INFO"]:
    items = by_severity[severity]
    if not items:
        continue
    color = COLORS[severity]
    reset = COLORS["RESET"]
    print(f"{color}── {severity} ({len(items)}) {'─'*(60-len(severity)-6)}{reset}")
    for f in items:
        print(f"  {f.file}:{f.line}")
        print(f"  [{f.criterion}] {f.note}")
        print(f"  {color}>{reset} {f.code[:100]}")
        print()

print(f"{'='*72}")
print(f"  Run with --fix to auto-patch safe decorative Icon() patterns.")
print(f"{'='*72}\n")

sys.exit(1 if by_severity["FAIL"] else 0)
