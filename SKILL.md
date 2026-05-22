---
name: macos-notes
description: Create, read, update, and organize notes in Apple Notes.app on macOS. Use for note-taking, lists, drafts, or any text the user wants to save.
---

# macOS Notes

Use this skill when the task is about Apple Notes.app on macOS.

## Main Rule

Use only `scripts/commands`.
Do not call `scripts/applescripts` directly.

## Requirements

- macOS with Notes.app
- Automation permissions for the terminal.

## Public Interface

Run commands from `scripts/commands`:

- `scripts/commands/folder/*`
- `scripts/commands/note/*`

## Commands

### Folder

```bash
scripts/commands/folder/create.sh
scripts/commands/folder/get.sh
scripts/commands/folder/list.sh
```

### Note

```bash
scripts/commands/note/append.sh
scripts/commands/note/count.sh
scripts/commands/note/create.sh
scripts/commands/note/delete.sh
scripts/commands/note/get.sh
scripts/commands/note/list.sh
scripts/commands/note/metadata.sh
scripts/commands/note/move.sh
scripts/commands/note/open-location.sh
scripts/commands/note/search.sh
scripts/commands/note/show.sh
scripts/commands/note/update.sh
```

## Safety Boundaries

- Note delete and write actions must be explicit.
- Internal AppleScript files are not public API.
