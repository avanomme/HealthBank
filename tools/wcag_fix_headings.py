#!/usr/bin/env python3
"""
Auto-fix: Wrap raw Text() widgets that use heading styles with Semantics(header: true).

This script is SAFE to run repeatedly — it skips Text() calls already inside
a Semantics(header: true) block, and skips Text() inside AppText (which handles
heading semantics automatically).

Usage:
    python3 tools/wcag_fix_headings.py [--dry-run]

Options:
    --dry-run   Print what would be changed without writing files.
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).parent.parent / "frontend" / "lib" / "src"
DRY_RUN = "--dry-run" in sys.argv

SKIP_FILES = {"ui_test_page.dart", "app_text.dart"}
SKIP_DIRS = {"generated", ".dart_tool", "l10n"}

# Heading style indicators
HEADING_RE = re.compile(
    r"AppTheme\.heading[1-4]|"
    r"textTheme\.displaySmall|textTheme\.displayMedium|textTheme\.displayLarge|"
    r"textTheme\.headlineSmall|textTheme\.headlineMedium"
)

changed_files = 0
total_fixes = 0


def find_matching_paren(text: str, start: int) -> int:
    """Find the index of the closing ')' that matches the '(' at text[start]."""
    depth = 0
    i = start
    in_string = False
    string_char = None
    while i < len(text):
        c = text[i]
        if in_string:
            if c == '\\':
                i += 2
                continue
            if c == string_char:
                in_string = False
        else:
            if c in ('"', "'"):
                in_string = True
                string_char = c
            elif c == '(':
                depth += 1
            elif c == ')':
                depth -= 1
                if depth == 0:
                    return i
        i += 1
    return -1


def already_wrapped(text: str, text_start: int) -> bool:
    """Check if the Text() at text_start is already inside Semantics(header: true)."""
    # Look back up to 150 chars for Semantics(header: true,
    look_back = text[max(0, text_start - 150):text_start]
    return "header: true" in look_back


def get_indent(line: str) -> str:
    return line[: len(line) - len(line.lstrip())]


def process_file(path: Path) -> int:
    content = path.read_text(encoding="utf-8")
    original = content
    fixes = 0

    # Find all Text( occurrences
    search_start = 0
    while True:
        # Find next standalone Text( (not part of AppText, RichText, etc.)
        match = re.search(r'(?<!\w)Text\(', content[search_start:])
        if not match:
            break

        abs_pos = search_start + match.start()

        # Skip if it's already wrapped
        if already_wrapped(content, abs_pos):
            search_start = abs_pos + 1
            continue

        # Find the matching closing paren
        paren_start = abs_pos + len("Text") # position of '('
        paren_end = find_matching_paren(content, paren_start)
        if paren_end < 0:
            search_start = abs_pos + 1
            continue

        call_text = content[abs_pos: paren_end + 1]

        # Check if this Text() uses a heading style
        if not HEADING_RE.search(call_text):
            search_start = abs_pos + 1
            continue

        # Skip if inside a comment
        line_start = content.rfind('\n', 0, abs_pos) + 1
        line_content = content[line_start: abs_pos]
        if line_content.lstrip().startswith("//"):
            search_start = abs_pos + 1
            continue

        # Determine indentation from the line containing Text(
        line = content[line_start: content.find('\n', abs_pos)]
        indent = get_indent(line)

        # Build the wrapped replacement
        # If single-line, keep single-line
        if '\n' not in call_text:
            replacement = f"Semantics(header: true, child: {call_text})"
        else:
            # Multi-line: indent the Semantics wrapper to match
            # Add 2 spaces to the original content for child: indentation
            indented_call = call_text.replace('\n', '\n  ')
            replacement = f"Semantics(\n{indent}  header: true,\n{indent}  child: {indented_call},\n{indent})"

        content = content[:abs_pos] + replacement + content[paren_end + 1:]
        fixes += 1
        search_start = abs_pos + len(replacement)

    if fixes > 0 and content != original:
        if DRY_RUN:
            print(f"  [DRY RUN] Would fix {fixes} heading(s) in {path.relative_to(ROOT.parent.parent.parent)}")
        else:
            path.write_text(content, encoding="utf-8")
            print(f"  Fixed {fixes} heading(s) in {path.relative_to(ROOT.parent.parent.parent)}")
    return fixes


print(f"\n{'='*60}")
print(f"  WCAG Heading Auto-Fix {'(DRY RUN)' if DRY_RUN else ''}")
print(f"{'='*60}\n")

dart_files = sorted(ROOT.rglob("*.dart"))
for dart_file in dart_files:
    if any(part in dart_file.parts for part in SKIP_DIRS):
        continue
    if dart_file.name in SKIP_FILES:
        continue
    try:
        n = process_file(dart_file)
        if n > 0:
            changed_files += 1
            total_fixes += n
    except Exception as e:
        print(f"  ERROR in {dart_file}: {e}")

print(f"\n{'='*60}")
print(f"  {'Would fix' if DRY_RUN else 'Fixed'} {total_fixes} heading(s) across {changed_files} file(s)")
print(f"{'='*60}\n")
