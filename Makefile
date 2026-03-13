.PHONY: dictionary-notes compile check test test-dictionary test-smoke

dictionary-notes:
	@sdef /System/Applications/Notes.app

compile:
	@set -euo pipefail; \
	find scripts -name '*.applescript' -print | while IFS= read -r file; do \
		osacompile -o /tmp/$$(echo "$$file" | tr '/' '_' | sed 's/\.applescript$$/.scpt/') "$$file"; \
	done

check:
	@osascript -e 'tell application "Notes" to get name' >/dev/null || { echo "check: Notes.app not available"; exit 1; }
	@echo "Notes.app is available"

test: test-dictionary test-smoke

test-dictionary:
	@bash tests/dictionary_contract.sh

test-smoke:
	@bash tests/smoke_notes.sh
