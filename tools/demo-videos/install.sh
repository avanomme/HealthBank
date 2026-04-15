#!/usr/bin/env bash
# Install dependencies for demo video generation
# Run once: bash tools/demo-videos/install.sh

set -e

echo "=== HealthBank Demo Video Tooling Setup ==="
echo ""

# Node + Playwright (web)
if ! command -v node &> /dev/null; then
  echo "Node.js not found. Install via: brew install node"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo ""
echo "Installing Playwright..."
cd "$SCRIPT_DIR/playwright"
npm install
npx playwright install chromium
echo "✓ Playwright installed"

# ffmpeg (optional, for post-processing)
if ! command -v ffmpeg &> /dev/null; then
  echo ""
  echo "ffmpeg not found — install for post-processing:"
  echo "  brew install ffmpeg"
else
  echo "✓ ffmpeg available"
fi

echo ""
echo "=== Setup complete ==="
echo ""
echo "Usage:"
echo "  make demo-web     — record web how-to videos (requires: make up)"
echo "  make demo-videos  — run all web demos"
echo ""
echo "Videos saved to: tools/demo-videos/output/"
