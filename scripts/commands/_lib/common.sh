#!/usr/bin/env bash
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
backend_script() { local e="$1" a="$2"; printf '%s/scripts/applescripts/%s/%s.applescript' "$ROOT_DIR" "$e" "$a"; }
run_backend() {
  local e="$1" a="$2"; shift 2
  local sp; sp="$(backend_script "$e" "$a")"
  [[ -f "$sp" ]] || { printf 'error: backend script not found: %s\n' "$sp" >&2; exit 1; }
  osascript "$sp" "$@"
}
