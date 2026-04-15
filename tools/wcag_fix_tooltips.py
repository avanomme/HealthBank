#!/usr/bin/env python3
"""
Fix missing IconButton tooltips and update audit script to detect Tooltip() parent wrappers.

Adds tooltip: property to each genuinely missing IconButton (identified by file:line).
Also updates wcag_audit.py to look back 3 lines for Tooltip( parent (eliminating false positives).
Adds required ARB keys to all three ARB files.
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).parent.parent
FRONTEND = ROOT / "frontend" / "lib" / "src"

changes: list[str] = []

def patch_file(rel_path: str, line_no: int, search: str, replacement: str, description: str):
    """
    Find `search` at or near `line_no` in rel_path and replace with `replacement`.
    line_no is 1-based. Searches ±5 lines from line_no for the match.
    """
    path = ROOT / rel_path
    if not path.exists():
        print(f"  SKIP (not found): {rel_path}")
        return
    content = path.read_text(encoding="utf-8")
    lines = content.splitlines(keepends=True)

    # find the search string near line_no
    idx = line_no - 1
    search_start = max(0, idx - 5)
    search_end = min(len(lines), idx + 10)

    # Find exact line containing `search`
    target_idx = None
    for i in range(search_start, search_end):
        if search in lines[i]:
            target_idx = i
            break

    if target_idx is None:
        print(f"  SKIP (search not found near line {line_no}): {rel_path}")
        print(f"    Looking for: {search!r}")
        return

    original_line = lines[target_idx]
    new_line = original_line.replace(search, replacement, 1)
    if new_line == original_line:
        print(f"  SKIP (no change): {rel_path}:{line_no}")
        return

    lines[target_idx] = new_line
    path.write_text("".join(lines), encoding="utf-8")
    print(f"  FIXED: {rel_path}:{target_idx + 1} — {description}")
    changes.append(f"{rel_path}:{target_idx + 1}")


def patch_multiline(rel_path: str, old_text: str, new_text: str, description: str):
    """Replace old_text with new_text anywhere in the file."""
    path = ROOT / rel_path
    if not path.exists():
        print(f"  SKIP (not found): {rel_path}")
        return
    content = path.read_text(encoding="utf-8")
    if old_text not in content:
        print(f"  SKIP (pattern not found): {rel_path}")
        return
    new_content = content.replace(old_text, new_text, 1)
    path.write_text(new_content, encoding="utf-8")
    print(f"  FIXED: {rel_path} — {description}")
    changes.append(rel_path)


# ── 1. Fix audit script: look back 3 lines for Tooltip( parent ───────────────
print("\n── Patching wcag_audit.py ──────────────────────────────────────────────")
audit_path = ROOT / "tools" / "wcag_audit.py"
audit = audit_path.read_text(encoding="utf-8")
old_check = '''        # Check up to 20 lines ahead for tooltip: (handles nested/multiline props)
        check_end = min(len(lines), i + 20)
        block = "\\n".join(lines[i:check_end])
        if "tooltip:" in block:
            continue'''
new_check = '''        # Check up to 20 lines ahead for tooltip: (handles nested/multiline props)
        check_end = min(len(lines), i + 20)
        block = "\\n".join(lines[i:check_end])
        if "tooltip:" in block:
            continue
        # Check up to 3 lines back for Tooltip( parent wrapper
        check_back = max(0, i - 3)
        parent_ctx = "\\n".join(lines[check_back:i])
        if "Tooltip(" in parent_ctx:
            continue'''
if old_check in audit:
    audit_path.write_text(audit.replace(old_check, new_check), encoding="utf-8")
    print("  FIXED: audit script now detects Tooltip() parent wrappers")
    changes.append("tools/wcag_audit.py")
else:
    print("  SKIP: pattern already patched or changed")


# ── 2. Add ARB keys ───────────────────────────────────────────────────────────
print("\n── Adding ARB keys ─────────────────────────────────────────────────────")

NEW_KEYS_EN = {
    "tooltipTogglePasswordVisibility": "Toggle password visibility",
    "tooltipClose": "Close",
    "tooltipGoBack": "Go back",
    "tooltipClearFilter": "Clear filter",
    "tooltipClearSearch": "Clear search",
    "tooltipCollapseSidebar": "Collapse section",
    "tooltipExpandSidebar": "Expand section",
}
NEW_KEYS_FR = {
    "tooltipTogglePasswordVisibility": "Afficher/masquer le mot de passe",
    "tooltipClose": "Fermer",
    "tooltipGoBack": "Retour",
    "tooltipClearFilter": "Effacer le filtre",
    "tooltipClearSearch": "Effacer la recherche",
    "tooltipCollapseSidebar": "Réduire la section",
    "tooltipExpandSidebar": "Développer la section",
}
NEW_KEYS_ES = {
    "tooltipTogglePasswordVisibility": "Mostrar/ocultar contraseña",
    "tooltipClose": "Cerrar",
    "tooltipGoBack": "Volver",
    "tooltipClearFilter": "Limpiar filtro",
    "tooltipClearSearch": "Limpiar búsqueda",
    "tooltipCollapseSidebar": "Contraer sección",
    "tooltipExpandSidebar": "Expandir sección",
}

ARB_FILES = {
    ROOT / "frontend/lib/src/core/l10n/arb/app_en.arb": NEW_KEYS_EN,
    ROOT / "frontend/lib/src/core/l10n/arb/app_fr.arb": NEW_KEYS_FR,
    ROOT / "frontend/lib/src/core/l10n/arb/app_es.arb": NEW_KEYS_ES,
}

for arb_path, keys in ARB_FILES.items():
    content = arb_path.read_text(encoding="utf-8")
    added = []
    for key, value in keys.items():
        if f'"{key}"' in content:
            continue
        # Insert before the final closing }
        entry = f'  "{key}": "{value}"'
        content = content.rstrip().rstrip("}").rstrip() + f",\n{entry}\n}}"
        added.append(key)
    if added:
        arb_path.write_text(content, encoding="utf-8")
        print(f"  ADDED to {arb_path.name}: {', '.join(added)}")
        changes.append(str(arb_path))
    else:
        print(f"  SKIP {arb_path.name}: all keys already present")


# ── 3. Patch missing IconButton tooltips ─────────────────────────────────────
print("\n── Patching IconButton tooltips ─────────────────────────────────────────")

# password visibility toggles — suffixIcon: IconButton( → add tooltip:
PASSWORD_VIS_FILES = [
    ("frontend/lib/src/features/auth/pages/change_password_page.dart", 179),
    ("frontend/lib/src/features/auth/pages/change_password_page.dart", 202),
    ("frontend/lib/src/features/auth/pages/change_password_page.dart", 234),
    ("frontend/lib/src/features/auth/pages/reset_password_page.dart", 161),
    ("frontend/lib/src/features/auth/pages/reset_password_page.dart", 209),
    ("frontend/lib/src/features/admin/widgets/reset_password_modal.dart", 233),
]
for rel, lno in PASSWORD_VIS_FILES:
    patch_file(
        rel, lno,
        "suffixIcon: IconButton(\n",
        "suffixIcon: IconButton(\n                    tooltip: context.l10n.tooltipTogglePasswordVisibility,\n",
        "add tooltip to password visibility toggle",
    )

# clear search / clear filter buttons
patch_file(
    "frontend/lib/src/features/surveys/pages/survey_list_page.dart", 158,
    "? IconButton(\n                          icon: const Icon(Icons.clear),",
    "? IconButton(\n                          tooltip: context.l10n.tooltipClearSearch,\n                          icon: const Icon(Icons.clear),",
    "add tooltip to clear search button",
)

# researcher_pull_data_page clear date buttons (suffixIcon with conditional IconButton)
# These are inside TextFormField suffixIcon — use tooltip: directly on IconButton
for lno in [1028, 1069]:
    patch_file(
        "frontend/lib/src/features/researcher/pages/researcher_pull_data_page.dart", lno,
        "? IconButton(\n                          icon: const Icon(Icons.clear, size: 18),",
        "? IconButton(\n                          tooltip: context.l10n.tooltipClearFilter,\n                          icon: const Icon(Icons.clear, size: 18),",
        f"add tooltip to clear date filter at line {lno}",
    )

# close buttons in modals/dialogs
CLOSE_BUTTONS = [
    ("frontend/lib/src/features/admin/pages/user_management_page.dart", 172),
    ("frontend/lib/src/features/researcher/pages/researcher_pull_data_page.dart", 1659),
    ("frontend/lib/src/features/surveys/widgets/question_bank_import_dialog.dart", 83),
    ("frontend/lib/src/features/surveys/widgets/survey_assignment_modal.dart", 330),
]
for rel, lno in CLOSE_BUTTONS:
    patch_file(
        rel, lno,
        "IconButton(\n",
        "IconButton(\n                    tooltip: context.l10n.tooltipClose,\n",
        "add tooltip to close button",
    )

# survey_builder_page close error (trailing: IconButton(...))
patch_file(
    "frontend/lib/src/features/surveys/pages/survey_builder_page.dart", 763,
    "trailing: IconButton(\n",
    "trailing: IconButton(\n          tooltip: context.l10n.tooltipClose,\n",
    "add tooltip to close error button",
)

# template_builder_page close error
patch_file(
    "frontend/lib/src/features/templates/pages/template_builder_page.dart", 285,
    "          IconButton(\n            icon: const Icon(Icons.close, size: 18),",
    "          IconButton(\n            tooltip: context.l10n.tooltipClose,\n            icon: const Icon(Icons.close, size: 18),",
    "add tooltip to close error button",
)

# question_bank_page back button (AppBar leading:)
patch_file(
    "frontend/lib/src/features/question_bank/pages/question_bank_page.dart", 116,
    "leading: IconButton(\n              icon: const Icon(Icons.arrow_back),",
    "leading: IconButton(\n              tooltip: context.l10n.tooltipGoBack,\n              icon: const Icon(Icons.arrow_back),",
    "add tooltip to back button",
)

# app_section_navbar sidebar toggle (dynamic: use tooltip property with ternary)
navbar_path = ROOT / "frontend/lib/src/core/widgets/basics/app_section_navbar.dart"
navbar = navbar_path.read_text(encoding="utf-8")
# Find the IconButton at line 258 area — it starts with "          IconButton("
# and has onPressed: canCollapse ? ...
OLD_NAV = "          IconButton(\n            onPressed: canCollapse ? () => _toggleSection(section.id) : null,"
NEW_NAV = ("          IconButton(\n"
           "            tooltip: canCollapse\n"
           "                ? (isExpanded\n"
           "                    ? context.l10n.tooltipCollapseSidebar\n"
           "                    : context.l10n.tooltipExpandSidebar)\n"
           "                : null,\n"
           "            onPressed: canCollapse ? () => _toggleSection(section.id) : null,")
if OLD_NAV in navbar:
    navbar_path.write_text(navbar.replace(OLD_NAV, NEW_NAV), encoding="utf-8")
    print("  FIXED: app_section_navbar.dart — dynamic collapse/expand tooltip")
    changes.append("frontend/lib/src/core/widgets/basics/app_section_navbar.dart")
else:
    print("  SKIP: app_section_navbar pattern not found (may already be fixed)")


# ── 4. Summary ────────────────────────────────────────────────────────────────
print(f"\n{'='*60}")
print(f"  Total files changed: {len(set(changes))}")
print(f"  Run: flutter gen-l10n && flutter analyze")
print(f"  Then: python3 tools/wcag_audit.py")
print(f"{'='*60}\n")
