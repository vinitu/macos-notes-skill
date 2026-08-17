# Repo Guide

This repo stores a skill for macOS Notes.app integration.

## Public interface and internal backend

- `scripts/commands/` is the only public command surface. Run commands from the repo root with paths like `scripts/commands/<entity>/<action>.sh`.
- `scripts/applescripts/` is the internal backend. Do not call AppleScript files directly from skill instructions.
- Only commands listed in `SKILL.md` are public. Other scripts may exist for internal use or legacy cleanup.

## Goal

- Document the AppleScript commands for Notes.app accurately.
- Prefer runnable examples over long prose.
- Treat note data as real user data — never delete or overwrite notes without explicit user approval.

## Repo Layout

- `AGENTS.md`: this file; rules for coding agents.
- `SKILL.md`: the skill contract and usage instructions for agents.
- `README.md`: public project overview and installation notes.
- `Makefile`: targets `dictionary-notes`, `check`, `compile`, `test` (test-dictionary + test-smoke).
- `scripts/applescripts/folder/list.applescript`: list note folder id and name.
- `scripts/applescripts/folder/create.applescript`, `scripts/applescripts/folder/get.applescript` (shared, container).
- `scripts/applescripts/note/list.applescript`, `scripts/applescripts/note/get.applescript`, `scripts/applescripts/note/create.applescript`, `scripts/applescripts/note/update.applescript`, `scripts/applescripts/note/append.applescript`, `scripts/applescripts/note/delete.applescript`, `scripts/applescripts/note/search.applescript`, `scripts/applescripts/note/metadata.applescript`, `scripts/applescripts/note/count.applescript`, `scripts/applescripts/note/move.applescript`, `scripts/applescripts/note/open-location.applescript`, `scripts/applescripts/note/show.applescript`.
- `scripts/applescripts/account/default-account.applescript`, `scripts/applescripts/account/default-folder.applescript`.
- `scripts/applescripts/attachment/list.applescript`, `scripts/applescripts/attachment/get.applescript`, `scripts/applescripts/attachment/save.applescript`.
- `scripts/applescripts/application/selection.applescript`.
- `scripts/tests/dictionary_contract.sh`: contract test against Notes.app scripting dictionary.
- `scripts/tests/smoke_notes.sh`: smoke test for script layer (skips when Notes.app not available).
- `.github/workflows/ci-pr.yml`: PR validation, auto-merge, version bump, tag, and release flow.
- `.github/workflows/ci-main.yml`: main-branch validation, patch tag, and release flow.

## Source of Truth

- `make dictionary-notes` / `make dictionary-standard` for the live Notes.app scripting dictionary.
- Live checks with `osascript` against Notes.app.

## Pitfalls / Environment Limits

- Notes.app automation may need **Notes** or **Full Disk Access** permission (System Settings → Privacy & Security).
- iCloud vs local notes may behave differently.
- Attachment operations may require Full Disk Access.

## Safety Rules

- Treat note data as real user data.
- Write operations (note/create, note/update, note/append, note/delete, note/move, folder/create) must be explicit.
- Use the `CodexTest_` prefix for any test data and clean up after tests.

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
