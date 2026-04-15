#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${1:-../output/web}"

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg is required but was not found in PATH." >&2
  exit 1
fi

while IFS= read -r -d '' input; do
  output="${input%.webm}.mp4"
  ffmpeg -y -nostdin -i "$input" -c:v libx264 -preset medium -crf 23 "$output" >/dev/null 2>&1
  echo "$output"
done < <(find "$ROOT_DIR" -type f -name 'video.webm' -print0 | sort -z)
