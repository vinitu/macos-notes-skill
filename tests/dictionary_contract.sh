#!/usr/bin/env bash
set -euo pipefail

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

make --no-print-directory dictionary-notes >"$tmp"

has_pattern() {
	local pattern="$1"
	if command -v rg >/dev/null 2>&1; then rg -q "$pattern" "$tmp"; else grep -q -- "$pattern" "$tmp"; fi
}

has_pattern '<class name="account"'
has_pattern '<class name="note"'
has_pattern '<class name="folder"'

printf 'dictionary_contract: ok\n'
