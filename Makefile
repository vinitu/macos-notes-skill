.PHONY: dictionary dictionary-notes dictionary-standard compile check test test-dictionary test-smoke test-integration

NOTES_SDEF := /System/Applications/Notes.app/Contents/Resources/Notes.sdef

dictionary:
	@printf '### Notes.app\n'
	@if [ -f "$(NOTES_SDEF)" ]; then cat "$(NOTES_SDEF)"; else sdef /System/Applications/Notes.app; fi
	@printf '\n### CocoaStandard.sdef\n'
	@cat /System/Library/ScriptingDefinitions/CocoaStandard.sdef

dictionary-notes:
	@if [ -f "$(NOTES_SDEF)" ]; then cat "$(NOTES_SDEF)"; else sdef /System/Applications/Notes.app; fi

dictionary-standard:
	@cat /System/Library/ScriptingDefinitions/CocoaStandard.sdef

compile:
	@set -euo pipefail; \
	find scripts/applescripts -name '*.applescript' -print | while IFS= read -r file; do \
		osacompile -o /tmp/$$(echo "$$file" | tr '/' '_' | sed 's/\.applescript$$/.scpt/') "$$file" || exit 1; \
	done; \
	find tests scripts/commands -name '*.sh' -print | while IFS= read -r file; do \
		bash -n "$$file" || exit 1; \
	done

check:
	@osascript -e 'tell application "Notes" to get name' >/dev/null || { echo "check: Notes not available"; exit 1; }
	@echo "Notes is available"

test: test-dictionary test-smoke

test-dictionary:
	@bash tests/dictionary_contract.sh

test-smoke:
	@bash tests/smoke_notes.sh

# Opt-in: creates and removes a temporary folder, note and attachment in Notes.app.
test-integration:
	@NOTES_SKILL_WRITE_TESTS=1 bash tests/write_notes.sh
