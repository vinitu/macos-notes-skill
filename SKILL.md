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

- `scripts/commands/account/*`
- `scripts/commands/application/*`
- `scripts/commands/attachment/*`
- `scripts/commands/folder/*`
- `scripts/commands/note/*`

## Commands

### Account

```bash
scripts/commands/account/default-account.sh
scripts/commands/account/default-folder.sh
```

### Application

```bash
scripts/commands/application/selection.sh
```

### Attachment

```bash
scripts/commands/attachment/get.sh
scripts/commands/attachment/list.sh
scripts/commands/attachment/save.sh
```

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

## JSON Contract

Note object:

- `id` (string)
- `name` (string)
- `body` (string)
- `creation_date` (string, ISO 8601)
- `modification_date` (string, ISO 8601)
- `folder` (string)

Folder object:

- `id` (string)
- `name` (string)
- `account` (string)

Account object:

- `name` (string)
- `default_folder` (string)

Scalar envelopes:

- `count`: `{"count": N}`
- `success/failure`: `{"success": true/false, "error": "..."}`

## Safety Boundaries

- Note delete and write actions must be explicit.
- Internal AppleScript files are not public API.
