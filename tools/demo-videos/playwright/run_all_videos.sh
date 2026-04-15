#!/usr/bin/env bash
# =============================================================================
# run_all_videos.sh — Resumable Playwright video recorder
#
# Runs every flow spec one at a time, tracks progress, and produces
# ready-to-deliver MP4 files under output/web/videos/.
#
# Usage:
#   ./run_all_videos.sh              # fresh run (or resume if progress file exists)
#   ./run_all_videos.sh --reset      # wipe progress and start over
#   ./run_all_videos.sh --export-only # skip recording, just (re-)export/rename MP4s
#
# Prerequisites:
#   • make demo-web-server running in another terminal
#   • npm packages installed: cd playwright && npm install
#   • ffmpeg available in PATH (for webm→mp4 conversion if needed)
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_ROOT="$DEMO_DIR/output/web"

# Progress file lives next to this script so it persists across runs
PROGRESS_FILE="$SCRIPT_DIR/.run_progress"

# ── Parse flags ───────────────────────────────────────────────────────────────
RESET=false
EXPORT_ONLY=false
for arg in "$@"; do
  case "$arg" in
    --reset)       RESET=true ;;
    --export-only) EXPORT_ONLY=true ;;
    --help|-h)
      sed -n '2,12p' "$0"
      exit 0
      ;;
  esac
done

# ── Colour helpers ────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; RESET_C='\033[0m'
ok()   { echo -e "${GREEN}✔${RESET_C}  $*"; }
warn() { echo -e "${YELLOW}⚠${RESET_C}  $*"; }
fail() { echo -e "${RED}✗${RESET_C}  $*"; }
info() { echo -e "${CYAN}→${RESET_C}  $*"; }

# ── Ordered list of all flow specs ───────────────────────────────────────────
mapfile -t ALL_SPECS < <(ls -1 "$SCRIPT_DIR/flows/"[0-9][0-9]_*.spec.ts | sort)

TOTAL=${#ALL_SPECS[@]}
info "Found $TOTAL flow specs."

# ── Reset progress if requested ───────────────────────────────────────────────
if $RESET; then
  warn "--reset: removing progress file. Will re-run all specs."
  rm -f "$PROGRESS_FILE"
fi

# ── Load progress ─────────────────────────────────────────────────────────────
declare -A DONE
if [[ -f "$PROGRESS_FILE" ]]; then
  # Each line: "<spec_basename> <run_label>"
  RUN_LABEL_FROM_FILE=""
  while IFS=' ' read -r spec_name run_lbl || [[ -n "$spec_name" ]]; do
    [[ -z "$spec_name" ]] && continue
    DONE["$spec_name"]="$run_lbl"
    RUN_LABEL_FROM_FILE="$run_lbl"   # last entry wins — they should all match
  done < "$PROGRESS_FILE"
  DONE_COUNT=${#DONE[@]}
  info "Resuming: $DONE_COUNT / $TOTAL already done (run label: $RUN_LABEL_FROM_FILE)."
  RUN_LABEL="${RUN_LABEL_FROM_FILE}"
else
  DONE_COUNT=0
  RUN_LABEL="$(date +%Y%m%d-%H%M%S)-web"
  info "New run — label: $RUN_LABEL"
fi

OUTPUT_DIR="$OUTPUT_ROOT/$RUN_LABEL"
mkdir -p "$OUTPUT_DIR"

# ── Skip to export if requested ───────────────────────────────────────────────
if $EXPORT_ONLY; then
  warn "--export-only: skipping recording step."
  DONE_COUNT=$TOTAL
fi

# ── Recording loop ────────────────────────────────────────────────────────────
PASS=0; FAIL_LIST=()

if ! $EXPORT_ONLY; then
  echo ""
  echo "════════════════════════════════════════════════════════════"
  echo "  Recording $TOTAL flow videos → $OUTPUT_DIR"
  echo "  Interrupt at any time — rerun this script to resume."
  echo "════════════════════════════════════════════════════════════"
  echo ""

  # Verify the dev server is up before starting
  if ! curl -s --max-time 3 http://localhost:62582 >/dev/null; then
    fail "Dev server not reachable on http://localhost:62582"
    echo "     Run 'make demo-web-server' in another terminal, then retry."
    exit 1
  fi

  IDX=0
  for spec_path in "${ALL_SPECS[@]}"; do
    spec_name="$(basename "$spec_path")"
    spec_stem="${spec_name%.spec.ts}"
    spec_output_dir="$OUTPUT_DIR/$spec_stem"
    IDX=$((IDX + 1))

    # Already completed in a previous run — skip
    if [[ -n "${DONE[$spec_name]+x}" ]]; then
      ok "[$IDX/$TOTAL] SKIP  $spec_name (already recorded)"
      PASS=$((PASS + 1))
      continue
    fi

    info "[$IDX/$TOTAL] START $spec_name"
    mkdir -p "$spec_output_dir"

    if (
      cd "$SCRIPT_DIR"
      PLAYWRIGHT_RUN_LABEL="$RUN_LABEL" \
      PLAYWRIGHT_OUTPUT_DIR="$spec_output_dir" \
        npx playwright test "flows/$spec_name" \
        --reporter=line \
        2>&1
    ); then
      ok "[$IDX/$TOTAL] PASS  $spec_name"
      PASS=$((PASS + 1))
      echo "$spec_name $RUN_LABEL" >> "$PROGRESS_FILE"
    else
      fail "[$IDX/$TOTAL] FAIL  $spec_name"
      FAIL_LIST+=("$spec_name")
      # Continue to next spec — don't stop the whole run
    fi
    echo ""
  done

  echo ""
  echo "════════════════════════════════════════════════════════════"
  echo "  Recording complete: $PASS passed, ${#FAIL_LIST[@]} failed"
  if [[ ${#FAIL_LIST[@]} -gt 0 ]]; then
    warn "Failed specs (will NOT appear in final export):"
    for f in "${FAIL_LIST[@]}"; do
      echo "    • $f"
    done
    echo ""
    echo "  Re-run this script to retry only the failed specs."
  fi
  echo "════════════════════════════════════════════════════════════"
  echo ""
fi

# ── Convert webm → mp4 (if Playwright produced webm files) ───────────────────
WEBM_COUNT=$(find "$OUTPUT_DIR" -type f -name 'video.webm' 2>/dev/null | wc -l | tr -d ' ')
if [[ "$WEBM_COUNT" -gt 0 ]]; then
  info "Converting $WEBM_COUNT webm file(s) to mp4..."
  if command -v ffmpeg >/dev/null 2>&1; then
    bash "$SCRIPT_DIR/convert_webm_to_mp4.sh" "$OUTPUT_DIR"
    ok "Conversion done."
  else
    warn "ffmpeg not found — skipping webm→mp4 conversion."
    warn "Install ffmpeg (brew install ffmpeg) and rerun with --export-only."
  fi
fi

# ── Export flat renamed MP4s ─────────────────────────────────────────────────
FLAT_DIR="$OUTPUT_ROOT/videos"
info "Exporting renamed videos to $FLAT_DIR ..."
bash "$SCRIPT_DIR/export_flat_mp4s.sh" "$OUTPUT_DIR" "$FLAT_DIR"

MP4_COUNT=$(find "$FLAT_DIR" -maxdepth 1 -name '*.mp4' | wc -l | tr -d ' ')
echo ""
ok "Done!  $MP4_COUNT MP4 file(s) ready in:"
echo "     $FLAT_DIR"

# Print summary of produced files
echo ""
find "$FLAT_DIR" -maxdepth 1 -name '*.mp4' | sort | while read -r f; do
  size=$(du -sh "$f" 2>/dev/null | cut -f1)
  echo "     ${size}   $(basename "$f")"
done
echo ""
