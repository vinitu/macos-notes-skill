#!/usr/bin/env bash
set -euo pipefail

# Opt-in integration test for commands that write to Notes.app.
# It creates a temporary folder, note and attachment, then removes them.
# Notes has no scripting command for permanent deletion, so cleanup moves the
# temporary folders to Recently Deleted. Empty that folder manually if needed.
# Run with: NOTES_SKILL_WRITE_TESTS=1 bash tests/write_notes.sh
if [[ "${NOTES_SKILL_WRITE_TESTS:-0}" != "1" ]]; then
	echo "write_notes: set NOTES_SKILL_WRITE_TESTS=1 to run write integration tests."
	exit 0
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CMD="$ROOT_DIR/scripts/commands"

if ! osascript -e 'tell application "Notes" to get name' >/dev/null 2>&1; then
	echo "write_notes: Notes.app not available, skipping."
	exit 0
fi

TEST_FOLDER="zz-macos-notes-skill-test-$$"
OTHER_FOLDER="zz-macos-notes-skill-other-$$"
TMP_DIR="$(mktemp -d)"
CREATED_FOLDER_IDS=()

fail() {
	echo "write_notes: $1" >&2
	exit 1
}

cleanup() {
	local folder_id
	for folder_id in "${CREATED_FOLDER_IDS[@]}"; do
		osascript - "$folder_id" >/dev/null 2>&1 <<'APPLESCRIPT' || true
on run argv
	set folderID to item 1 of argv
	tell application "Notes"
		set matches to every folder whose id is folderID
		if (count of matches) > 0 then
			set f to item 1 of matches
			move f to folder "Recently Deleted"
		end if
	end tell
end run
APPLESCRIPT
	done
	rm -rf "$TMP_DIR"
}
trap cleanup EXIT

run_cmd() {
	local label="$1"
	shift
	local out
	if ! out="$("$@" 2>&1)"; then
		fail "$label failed: $out"
	fi
	printf '%s' "$out"
}

assert_eq() {
	local expected="$1" actual="$2" label="$3"
	[[ "$actual" == "$expected" ]] || fail "$label: expected [$expected], got [$actual]"
}

python3 - "$TMP_DIR/fixture.png" <<'PY'
import base64
import sys

data = base64.b64decode(
    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Y9ZQmcAAAAASUVORK5CYII="
)
with open(sys.argv[1], "wb") as handle:
    handle.write(data)
PY

# folder/create must return "created<TAB>id".
folder_out="$(run_cmd "folder/create" "$CMD/folder/create.sh" "$TEST_FOLDER")"
folder_line="${folder_out%%$'\n'*}"
[[ "$folder_line" == created$'\t'* ]] || fail "folder/create did not return created<TAB>id: $folder_out"
folder_id="${folder_line#*$'\t'}"
[[ "$folder_id" == x-coredata://* ]] || fail "folder/create returned an invalid ID: $folder_id"
CREATED_FOLDER_IDS+=("$folder_id")

# folder/get must accept a folder ID.
folder_name="$(run_cmd "folder/get by id" "$CMD/folder/get.sh" "$folder_id" name)"
assert_eq "$TEST_FOLDER" "$folder_name" "folder/get by id"

# note/create must return "created<TAB>id" and accept a folder ID.
note_out="$(run_cmd "note/create" "$CMD/note/create.sh" "$folder_id" "fixture-note" "<div>fixture-note</div>")"
note_line="${note_out%%$'\n'*}"
[[ "$note_line" == created$'\t'* ]] || fail "note/create did not return created<TAB>id: $note_out"
note_id="${note_line#*$'\t'}"
[[ "$note_id" == x-coredata://* ]] || fail "note/create returned an invalid ID: $note_id"

# note/get must accept a folder ID with a note name.
get_by_name="$(run_cmd "note/get by folder id and name" "$CMD/note/get.sh" "$folder_id" "fixture-note")"
grep -q "fixture-note" <<<"$get_by_name" || fail "note/get by folder id and name did not return the note"

# note/list and note/count must accept a folder ID.
list_out="$(run_cmd "note/list by folder id" "$CMD/note/list.sh" "$folder_id")"
grep -Fq "$note_id" <<<"$list_out" || fail "note/list by folder id did not return the new note"
count_out="$(run_cmd "note/count by folder id" "$CMD/note/count.sh" "$folder_id")"
[[ "$count_out" =~ ^[0-9]+$ ]] || fail "note/count returned a non-number: $count_out"

# note/metadata must accept both IDs.
metadata_out="$(run_cmd "note/metadata by ids" "$CMD/note/metadata.sh" "$folder_id" "$note_id")"
grep -qx "Name: fixture-note" <<<"$metadata_out" || fail "note/metadata did not return the note name"
grep -qx "ID: $note_id" <<<"$metadata_out" || fail "note/metadata did not return the note ID"

# Attach a file to the fixture note so attachment commands have a stable fixture.
osascript - "$note_id" "$TMP_DIR/fixture.png" >/dev/null <<'APPLESCRIPT'
on run argv
	set noteID to item 1 of argv
	set filePath to item 2 of argv
	set testFile to POSIX file filePath
	tell application "Notes"
		set n to first note whose id is noteID
		make new attachment at n with data testFile
	end tell
end run
APPLESCRIPT

# attachment/list must expose name, id and the 1-based index used by save.
attachment_out="$(run_cmd "attachment/list by ids" "$CMD/attachment/list.sh" "$folder_id" "$note_id")"
attachment_line="${attachment_out%%$'\n'*}"
IFS=$'\t' read -r attachment_name attachment_id attachment_index <<<"$attachment_line"
assert_eq "fixture.png" "$attachment_name" "attachment/list name"
[[ "$attachment_id" == x-coredata://* ]] || fail "attachment/list returned an invalid ID: $attachment_id"
assert_eq "1" "$attachment_index" "attachment/list index"

# attachment/get must accept both IDs and an attachment index.
attachment_get="$(run_cmd "attachment/get by index" "$CMD/attachment/get.sh" "$folder_id" "$note_id" 1)"
grep -qx "name: fixture.png" <<<"$attachment_get" || fail "attachment/get did not resolve the attachment index"

# attachment/save must accept an index and a full file path.
run_cmd "attachment/save by index" "$CMD/attachment/save.sh" "$folder_id" "$note_id" 1 "$TMP_DIR/from-index.png" >/dev/null
[[ -s "$TMP_DIR/from-index.png" ]] || fail "attachment/save by index produced no file"

# attachment/save must accept an existing directory and keep the filename.
mkdir -p "$TMP_DIR/outdir"
run_cmd "attachment/save to directory" "$CMD/attachment/save.sh" "$folder_id" "$note_id" "fixture.png" "$TMP_DIR/outdir" >/dev/null
[[ -s "$TMP_DIR/outdir/fixture.png" ]] || fail "attachment/save to directory did not create fixture.png"

# Tables are attachments without a filename. They cannot be saved as files,
# but the command must fail with a clear error instead of an AppleEvent error.
run_cmd "note/append table" "$CMD/note/append.sh" "$folder_id" "$note_id" "<table><tr><td>a</td><td>b</td></tr></table>" >/dev/null
attachment_out="$(run_cmd "attachment/list after table" "$CMD/attachment/list.sh" "$folder_id" "$note_id")"
grep -q $'^<unnamed>\t' <<<"$attachment_out" || fail "attachment/list did not mark the table as <unnamed>"
if save_out="$("$CMD/attachment/save.sh" "$folder_id" "$note_id" 2 "$TMP_DIR/table-export" 2>&1)"; then
	fail "attachment/save unexpectedly exported a non-file attachment"
fi
grep -qi "non-file" <<<"$save_out" || fail "attachment/save did not explain the non-file attachment failure: $save_out"

# note/update, note/append and note/get must accept note IDs.
run_cmd "note/update by id" "$CMD/note/update.sh" "$folder_id" "$note_id" "<div>updated-body</div>" >/dev/null
get_out="$(run_cmd "note/get by id after update" "$CMD/note/get.sh" "$folder_id" "$note_id")"
grep -q "updated-body" <<<"$get_out" || fail "note/get by id did not return the updated body"

run_cmd "note/append by id" "$CMD/note/append.sh" "$folder_id" "$note_id" "<div>appended</div>" >/dev/null
get_out="$(run_cmd "note/get by id after append" "$CMD/note/get.sh" "$folder_id" "$note_id")"
grep -q "appended" <<<"$get_out" || fail "note/get by id did not return the appended body"

# note/move must accept a note ID and a target folder ID.
other_out="$(run_cmd "folder/create other" "$CMD/folder/create.sh" "$OTHER_FOLDER")"
other_line="${other_out%%$'\n'*}"
other_id="${other_line#*$'\t'}"
CREATED_FOLDER_IDS+=("$other_id")
run_cmd "note/move by id" "$CMD/note/move.sh" "$folder_id" "$note_id" "$other_id" >/dev/null
get_out="$(run_cmd "note/get after move" "$CMD/note/get.sh" "$other_id" "$note_id")"
grep -q "updated-body" <<<"$get_out" || fail "note/get after move did not return the note"

# note/delete must accept a note ID.
run_cmd "note/delete by id" "$CMD/note/delete.sh" "$other_id" "$note_id" >/dev/null
if "$CMD/note/list.sh" "$other_id" | grep -Fq "$note_id"; then
	fail "note/delete by id left the note in the target folder"
fi

# note/list without an argument must print its usage contract.
usage="$("$CMD/note/list.sh" 2>&1 || true)"
case "$usage" in
Usage:*) : ;;
*) fail "note/list without an argument did not print usage: $usage" ;;
esac

echo "write_notes: ok"
