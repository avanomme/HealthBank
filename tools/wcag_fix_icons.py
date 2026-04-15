#!/usr/bin/env python3
"""
Wrap bare standalone Icon() widgets in ExcludeSemantics.

Targets WARN findings from wcag_audit.py — standalone Icon() widgets
not in widget property positions (prefixIcon/icon/leading etc. are skipped
by the audit script). These are genuinely decorative icons in widget trees.

Usage:  python3 tools/wcag_fix_icons.py [--dry-run]
"""

import re
import sys
from pathlib import Path

DRY_RUN = "--dry-run" in sys.argv
ROOT = Path(__file__).parent.parent

# All (file, 1-based-line) pairs from the WARN audit output
TARGETS = [
    ("frontend/lib/src/core/widgets/basics/app_accordion.dart", 120),
    ("frontend/lib/src/core/widgets/data_display/data_table.dart", 1024),
    ("frontend/lib/src/core/widgets/data_display/data_table.dart", 1025),
    ("frontend/lib/src/core/widgets/feedback/async_error_handler.dart", 74),
    ("frontend/lib/src/core/widgets/micro/app_your_answer_row.dart", 34),
    ("frontend/lib/src/features/admin/pages/database_viewer_page.dart", 291),
    ("frontend/lib/src/features/admin/pages/database_viewer_page.dart", 299),
    ("frontend/lib/src/features/admin/pages/database_viewer_page.dart", 386),
    ("frontend/lib/src/features/admin/pages/database_viewer_page.dart", 482),
    ("frontend/lib/src/features/admin/pages/database_viewer_page.dart", 484),
    ("frontend/lib/src/features/admin/pages/database_viewer_page.dart", 577),
    ("frontend/lib/src/features/admin/pages/database_viewer_page.dart", 611),
    ("frontend/lib/src/features/admin/pages/database_viewer_page.dart", 644),
    ("frontend/lib/src/features/admin/pages/database_viewer_page.dart", 844),
    ("frontend/lib/src/features/admin/pages/database_viewer_page.dart", 882),
    ("frontend/lib/src/features/admin/pages/database_viewer_page.dart", 1061),
    ("frontend/lib/src/features/admin/pages/user_management_page.dart", 162),
    ("frontend/lib/src/features/admin/widgets/admin_scaffold.dart", 292),
    ("frontend/lib/src/features/admin/widgets/admin_scaffold.dart", 310),
    ("frontend/lib/src/features/admin/widgets/reset_password_modal.dart", 132),
    ("frontend/lib/src/features/auth/pages/change_password_page.dart", 148),
    ("frontend/lib/src/features/auth/pages/deactivated_notice_page.dart", 37),
    ("frontend/lib/src/features/auth/pages/reset_password_page.dart", 297),
    ("frontend/lib/src/features/hcp_clients/pages/hcp_client_list_page.dart", 313),
    ("frontend/lib/src/features/hcp_clients/pages/hcp_dashboard_page.dart", 226),
    ("frontend/lib/src/features/messaging/pages/conversation_page.dart", 206),
    ("frontend/lib/src/features/messaging/pages/messaging_inbox_page.dart", 551),
    ("frontend/lib/src/features/messaging/pages/messaging_inbox_page.dart", 613),
    ("frontend/lib/src/features/messaging/pages/messaging_inbox_page.dart", 802),
    ("frontend/lib/src/features/messaging/pages/messaging_inbox_page.dart", 2017),
    ("frontend/lib/src/features/messaging/widgets/recipient_tile.dart", 53),
    ("frontend/lib/src/features/participant/pages/participant_dashboard_page.dart", 238),
    ("frontend/lib/src/features/participant/pages/participant_dashboard_page.dart", 301),
    ("frontend/lib/src/features/participant/pages/participant_dashboard_page.dart", 341),
    ("frontend/lib/src/features/participant/pages/participant_results_page.dart", 379),
    ("frontend/lib/src/features/participant/pages/participant_results_page.dart", 482),
    ("frontend/lib/src/features/participant/pages/participant_results_page.dart", 581),
    ("frontend/lib/src/features/participant/pages/participant_results_page.dart", 663),
    ("frontend/lib/src/features/participant/pages/participant_results_page.dart", 687),
    ("frontend/lib/src/features/participant/pages/participant_results_page.dart", 704),
    ("frontend/lib/src/features/participant/pages/participant_results_page.dart", 737),
    ("frontend/lib/src/features/participant/pages/participant_results_page.dart", 767),
    ("frontend/lib/src/features/participant/pages/participant_results_page.dart", 798),
    ("frontend/lib/src/features/participant/widgets/notification_banner.dart", 45),
    ("frontend/lib/src/features/participant/widgets/participant_chart_section.dart", 98),
    ("frontend/lib/src/features/public/error/not_found_page.dart", 15),
    ("frontend/lib/src/features/question_bank/widgets/question_bank_form_dialog.dart", 253),
    ("frontend/lib/src/features/researcher/pages/researcher_pull_data_page.dart", 833),
    ("frontend/lib/src/features/researcher/pages/researcher_pull_data_page.dart", 1035),
    ("frontend/lib/src/features/researcher/pages/researcher_pull_data_page.dart", 1077),
    ("frontend/lib/src/features/surveys/pages/survey_builder_page.dart", 725),
    ("frontend/lib/src/features/surveys/widgets/question_bank_import_dialog.dart", 72),
    ("frontend/lib/src/features/surveys/widgets/question_bank_import_dialog.dart", 214),
    ("frontend/lib/src/features/surveys/widgets/survey_preview_dialog.dart", 115),
    ("frontend/lib/src/features/surveys/widgets/survey_preview_dialog.dart", 292),
    ("frontend/lib/src/features/templates/pages/template_builder_page.dart", 277),
    ("frontend/lib/src/features/templates/pages/template_builder_page.dart", 371),
    ("frontend/lib/src/features/templates/widgets/template_preview_dialog.dart", 90),
    ("frontend/lib/src/features/templates/widgets/template_preview_dialog.dart", 330),
]

# ── Icon expression finder ────────────────────────────────────────────────────
# Matches the start of an Icon expression on a line: optional "const ", then "Icon("
# May be preceded by: "child: ", ": ", "? " (ternary)
ICON_START_RE = re.compile(r"((?:const\s+)?Icon\()")


def find_icon_extent(lines: list[str], start_line_idx: int) -> tuple[int, int, int, int]:
    """
    Find the full extent of an Icon() expression starting at `start_line_idx`.
    Returns (start_line, start_col, end_line, end_col) — all 0-based.
    end_col is the column AFTER the final ')'.
    """
    line = lines[start_line_idx]
    m = ICON_START_RE.search(line)
    if not m:
        return None

    start_col = m.start(1)
    # Find the `Icon(` opening paren position
    icon_paren_pos = line.index("(", m.start())
    depth = 0
    for li in range(start_line_idx, len(lines)):
        scan_line = lines[li]
        col_start = icon_paren_pos if li == start_line_idx else 0
        for ci, ch in enumerate(scan_line[col_start:], col_start):
            if ch == "(":
                depth += 1
            elif ch == ")":
                depth -= 1
                if depth == 0:
                    return (start_line_idx, start_col, li, ci + 1)
    return None


def wrap_icon(lines: list[str], start_line_idx: int) -> bool:
    """
    Wrap the Icon() expression at start_line_idx in ExcludeSemantics(child: ...).
    Returns True if a change was made.
    """
    extent = find_icon_extent(lines, start_line_idx)
    if not extent:
        return False

    sl, sc, el, ec = extent
    indent = len(lines[sl]) - len(lines[sl].lstrip())

    if sl == el:
        # Single-line: Icon(...) → ExcludeSemantics(child: Icon(...))
        line = lines[sl]
        old_expr = line[sc:ec]
        # Check it's not already wrapped
        before = line[:sc].rstrip()
        if before.endswith("ExcludeSemantics(child:"):
            return False
        new_expr = f"ExcludeSemantics(child: {old_expr})"
        lines[sl] = line[:sc] + new_expr + line[ec:]
    else:
        # Multi-line: insert ExcludeSemantics(child: ... before, ) after
        # Check not already wrapped
        before = lines[sl][:sc].rstrip()
        if before.endswith("ExcludeSemantics(child:"):
            return False
        # Wrap opening line
        lines[sl] = lines[sl][:sc] + "ExcludeSemantics(child: " + lines[sl][sc:]
        # Add closing ) on end line (shift ec by 0 since we didn't touch that line)
        # But now ec position is still valid in the end line
        end_line = lines[el]
        lines[el] = end_line[:ec] + ")" + end_line[ec:]

    return True


# ── Process files ─────────────────────────────────────────────────────────────
# Group targets by file, process in reverse line order to avoid offset drift
from collections import defaultdict

by_file: dict[str, list[int]] = defaultdict(list)
for rel, lno in TARGETS:
    by_file[rel].append(lno)

fixed = 0
skipped = 0

for rel_path, line_numbers in sorted(by_file.items()):
    path = ROOT / rel_path
    if not path.exists():
        print(f"  MISSING: {rel_path}")
        continue

    content = path.read_text(encoding="utf-8")
    lines = content.splitlines(keepends=True)

    changed = False
    # Process in reverse order so line numbers don't shift
    for lno in sorted(line_numbers, reverse=True):
        idx = lno - 1  # 0-based
        if idx >= len(lines):
            print(f"  SKIP (line OOB): {rel_path}:{lno}")
            skipped += 1
            continue

        # Try wrapping
        if wrap_icon(lines, idx):
            fixed += 1
            changed = True
            if DRY_RUN:
                print(f"  [DRY] {rel_path}:{lno}")
            else:
                print(f"  FIXED: {rel_path}:{lno}  →  {lines[idx].strip()[:80]}")
        else:
            skipped += 1
            print(f"  SKIP (already wrapped or not found): {rel_path}:{lno}")

    if changed and not DRY_RUN:
        path.write_text("".join(lines), encoding="utf-8")

print(f"\n  Fixed: {fixed}  |  Skipped: {skipped}")
print(f"  Run: flutter analyze --no-fatal-infos")
print(f"  Then: python3 tools/wcag_audit.py")
