#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CMD="$ROOT_DIR/scripts/commands"

# Skip only when Notes.app itself is unavailable (CI runners without a session).
if ! osascript -e 'tell application "Notes" to get name' >/dev/null 2>&1; then
	echo "smoke_notes: Notes.app not available, skipping."
	exit 0
fi

fail() {
	echo "smoke_notes: $1" >&2
	exit 1
}

# Every read-only command must run through the public surface and exit 0.
run_cmd() {
	local label="$1"
	shift
	local out
	if ! out="$("$@" 2>&1)"; then
		fail "$label failed: $out"
	fi
	printf '%s' "$out"
}

# account: no arguments, must return the default account and folder names.
account="$(run_cmd "account/default-account" "$CMD/account/default-account.sh")"
[ -n "$account" ] || fail "account/default-account returned nothing"

default_folder="$(run_cmd "account/default-folder" "$CMD/account/default-folder.sh")"
[ -n "$default_folder" ] || fail "account/default-folder returned nothing"

# folder: list is the entry point for every note command below.
folder_list="$(run_cmd "folder/list" "$CMD/folder/list.sh")"
[ -n "$folder_list" ] || fail "folder/list returned nothing"

first_folder_line="$(printf '%s\n' "$folder_list" | head -1)"
first_folder_id="$(printf '%s\n' "$first_folder_line" | cut -f1)"
first_folder="$(printf '%s\n' "$first_folder_line" | cut -f2)"
[ -n "$first_folder" ] || fail "folder/list produced no folder name in column 2"

run_cmd "folder/get" "$CMD/folder/get.sh" "$first_folder" >/dev/null

# folder/get must also accept the stable ID returned by folder/list.
folder_name_by_id="$(run_cmd "folder/get by id" "$CMD/folder/get.sh" "$first_folder_id" name)"
[ "$folder_name_by_id" = "$first_folder" ] || fail "folder/get by id returned $folder_name_by_id, expected $first_folder"

# note: list and count for a real folder, by name and by ID.
note_list="$(run_cmd "note/list" "$CMD/note/list.sh" "$first_folder")"
run_cmd "note/list by id" "$CMD/note/list.sh" "$first_folder_id" >/dev/null

count="$(run_cmd "note/count" "$CMD/note/count.sh" "$first_folder")"
case "$count" in
'' | *[!0-9]*) fail "note/count returned a non-number: $count" ;;
esac

# note/metadata is read-only and must accept both folder and note IDs.
first_note_line="$(printf '%s\n' "$note_list" | head -1)"
if [ -n "$first_note_line" ]; then
	first_note_id="$(printf '%s\n' "$first_note_line" | cut -f1)"
	metadata="$(run_cmd "note/metadata by ids" "$CMD/note/metadata.sh" "$first_folder_id" "$first_note_id")"
	case "$metadata" in
	*"ID: $first_note_id"*) : ;;
	*) fail "note/metadata by ids did not return the requested note ID" ;;
	esac
fi

# note/list without an argument must report its usage contract.
list_usage="$("$CMD/note/list.sh" 2>&1 || true)"
case "$list_usage" in
Usage:*) : ;;
*) fail "note/list without an argument did not print usage: $list_usage" ;;
esac

# note/search accepts any query; an empty result set is still a success.
run_cmd "note/search" "$CMD/note/search.sh" "smoke_notes_query_no_match" >/dev/null

# Commands that need a note argument are checked for their usage contract only,
# so the smoke test never reads, writes or deletes real user notes.
for entry in "note/get" "note/metadata" "attachment/list"; do
	usage="$("$CMD/$entry.sh" 2>&1 || true)"
	case "$usage" in
	Usage:*) : ;;
	*) fail "$entry did not report its usage contract: $usage" ;;
	esac
done

# application/selection returns the current selection, which may be empty.
run_cmd "application/selection" "$CMD/application/selection.sh" >/dev/null

echo "smoke_notes: ok"
