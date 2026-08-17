#!/usr/bin/env bash
# Shared helpers for public shell commands.
#
# AppleScript backends under scripts/applescripts return plain text (bare
# numbers, TSV lines, or single status words). These helpers wrap that raw
# output into the JSON envelopes documented in SKILL.md so every public
# command emits valid JSON on stdout.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

JQ_BIN="${JQ_BIN:-}"
if [[ -z "$JQ_BIN" ]]; then
  if JQ_BIN="$(command -v jq 2>/dev/null)"; then
    :
  elif [[ -x "/opt/homebrew/bin/jq" ]]; then
    JQ_BIN="/opt/homebrew/bin/jq"
  else
    JQ_BIN=""
  fi
fi

# Error envelope (always exits 1).
json_fail() { local msg="$1"; printf '{"success":false,"error":"%s"}\n' "$msg"; exit 1; }
json_ok() { local payload="${1:-{}}"; printf '{"success":true,"data":%s}\n' "$payload"; }
require_arg() { local v="${1:-}" l="$2"; [[ -z "$v" ]] && json_fail "missing ${l}"; }

# Resolve an internal AppleScript backend path.
backend_script() { local e="$1" a="$2"; printf '%s/scripts/applescripts/%s/%s.applescript' "$ROOT_DIR" "$e" "$a"; }

require_jq() { [[ -n "$JQ_BIN" ]] || json_fail "jq required"; }

# Wrap a bare numeric count as {"count": N}.
json_wrap_count() {
  local raw="$1"
  require_jq
  local n
  n="$(printf '%s' "$raw" | tr -d '[:space:]')"
  [[ "$n" =~ ^[0-9]+$ ]] || json_fail "count backend did not return a number"
  printf '{"count":%s}\n' "$n"
}

# Wrap TSV lines into a JSON array of objects.
# Usage: json_wrap_list <raw> <field> [<field>...]
# Each non-empty line is split on tabs and zipped with the field names.
json_wrap_list() {
  local raw="$1"; shift
  require_jq
  local fields_json
  fields_json="$(printf '%s\n' "$@" | "$JQ_BIN" -R -s 'split("\n") | map(select(length > 0))')"
  printf '%s' "$raw" | "$JQ_BIN" -R -s --argjson fields "$fields_json" '
    [ split("\n")[] | select(length > 0)
      | split("\t") as $row
      | reduce range(0; ($fields | length)) as $i ({}; . + {($fields[$i]): ($row[$i] // "")}) ]
  '
}

# Wrap a status word (created/deleted/moved/...) as {"success": true, "data": "..."}.
json_wrap_status() {
  local raw="$1"
  require_jq
  printf '%s' "$raw" | "$JQ_BIN" -R -s '{success:true, data:.}'
}

# Wrap arbitrary multi-line text as {"success": true, "data": "..."}.
json_wrap_text() {
  local raw="$1"
  require_jq
  printf '%s' "$raw" | "$JQ_BIN" -R -s '{success:true, data:.}'
}

# Field names for list-style backends, keyed by entity.
list_fields() {
  case "$1" in
    folder) echo "id name" ;;
    note) echo "id name modification_date" ;;
    attachment) echo "name id" ;;
    application) echo "name" ;;
    *) echo "name" ;;
  esac
}

# Field names for search-style backends, keyed by entity.
search_fields() {
  case "$1" in
    note) echo "name modification_date" ;;
    *) echo "name" ;;
  esac
}

# Run an AppleScript backend and wrap its output in the JSON envelope that
# matches the action. Usage: run_backend <entity> <action> [args...]
run_backend() {
  local e="$1" a="$2"; shift 2
  local sp
  sp="$(backend_script "$e" "$a")"
  [[ -f "$sp" ]] || json_fail "backend script not found: ${sp}"

  local raw
  if ! raw="$(osascript "$sp" "$@" 2>/dev/null)"; then
    json_fail "backend failed: ${a}"
  fi

  case "$a" in
    count)
      json_wrap_count "$raw"
      ;;
    list)
      # shellcheck disable=SC2086
      json_wrap_list "$raw" $(list_fields "$e")
      ;;
    search)
      # shellcheck disable=SC2086
      json_wrap_list "$raw" $(search_fields "$e")
      ;;
    get|metadata)
      json_wrap_text "$raw"
      ;;
    *)
      # create, append, update, delete, move, open-location, show, save, ...
      json_wrap_status "$raw"
      ;;
  esac
}