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

## Output Rules

- Commands print the raw AppleScript result as plain text. There is no JSON envelope.
- Multi-row results are tab-separated, one record per line.
- `--json`, `--plain`, and `--format=plain|json` are not supported.
- A command called without its required arguments prints `Usage: <backend>.applescript <args>` and exits 0, so check the output, not only the exit code.
- `show.sh` and `open-location.sh` bring Notes.app to the front as a side effect.

## Output Contract

Tab-separated columns per command:

| Command | Columns |
| --- | --- |
| `folder/list.sh` | `id`, `name` |
| `note/list.sh <folder>` | `id`, `name`, `modification date` |
| `note/search.sh <query>` | `name`, `modification date` |
| `note/count.sh <folder>` | a single integer |
| `account/default-account.sh` | account name |
| `account/default-folder.sh` | folder name |
| `application/selection.sh` | selected note names, one per line (empty when nothing is selected) |
| `folder/get.sh <folder> [property]` | `name:`, `id:`, `shared:`, `container:` lines, or one value when a property is named |

Dates come from AppleScript in the local system format, not ISO 8601.

`container:` is the parent of the folder, which can be another folder rather than an account. It is empty when Notes refuses to resolve it.

## Safety Boundaries

- Note delete and write actions must be explicit.
- Internal AppleScript files are not public API.
