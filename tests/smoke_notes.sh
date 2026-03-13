#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! osascript -e 'tell application "Notes" to get name' >/dev/null 2>&1; then
	echo "smoke_notes: Notes.app not available."
	exit 0
fi

# Script layer: list folders
folder_list="$(osascript "$ROOT_DIR/scripts/folder/list.applescript" 2>&1)" || { echo "smoke_notes: Notes not running, skipping."; exit 0; }
printf '%s\n' "$folder_list" >/dev/null || { echo "smoke_notes: folder list failed." >&2; exit 1; }

# Script layer: list notes in first folder
first_folder="$(echo "$folder_list" | head -1 | cut -f2)"
note_list="$(osascript "$ROOT_DIR/scripts/note/list.applescript" "$first_folder" 2>&1)" || true
printf '%s\n' "$note_list" >/dev/null || true

# note/count for first folder
if [ -n "$first_folder" ]; then
	osascript "$ROOT_DIR/scripts/note/count.applescript" "$first_folder" >/dev/null 2>&1 || true
fi

echo "smoke_notes: ok"
