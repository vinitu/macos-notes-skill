# Repo Guide

This repo stores a skill for macOS Notes.app integration.

## Goal

- Document the AppleScript commands for Notes.app accurately.
- Prefer runnable examples over long prose.
- Treat note data as real user data — never delete or overwrite notes without explicit user approval.

## Repo Layout

- `AGENTS.md`: this file; rules for coding agents.
- `SKILL.md`: the skill contract and usage instructions for agents.
- `README.md`: public project overview and installation notes.
- `Makefile`: targets `dictionary-notes`, `check`, `compile`, `test` (test-dictionary + test-smoke).
- `scripts/folder/list.applescript`: list note folder id and name.
- `scripts/folder/create.applescript`, `scripts/folder/get.applescript` (shared, container).
- `scripts/note/list.applescript`, `scripts/note/get.applescript`, `scripts/note/create.applescript`, `scripts/note/update.applescript`, `scripts/note/append.applescript`, `scripts/note/delete.applescript`, `scripts/note/search.applescript`, `scripts/note/metadata.applescript`, `scripts/note/count.applescript`, `scripts/note/move.applescript`, `scripts/note/open-location.applescript`, `scripts/note/show.applescript`.
- `scripts/account/default-account.applescript`, `scripts/account/default-folder.applescript`.
- `scripts/attachment/list.applescript`, `scripts/attachment/get.applescript`, `scripts/attachment/save.applescript`.
- `scripts/application/selection.applescript`.
- `tests/dictionary_contract.sh`: contract test against Notes.app scripting dictionary.
- `tests/smoke_notes.sh`: smoke test for script layer (skips when Notes.app not available).
- `.github/workflows/ci-pr.yml`, `ci-main.yml`: CI on PR and push to main.

## Validation

After making changes:
- run `make check` to ensure Notes.app is available;
- run `make test` to run dictionary contract and smoke tests;
- run `make compile` to compile all AppleScript files (syntax check);
- update `SKILL.md` when command coverage changes.

## Editing Rules

- Keep docs in simple English.
- Do not claim support for a feature unless it is verified with `osascript` on macOS.
- Treat note data as real user data; never delete or overwrite notes without explicit user approval.
