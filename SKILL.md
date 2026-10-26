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
- `folder/create.sh` and `note/create.sh` return `created` and the new object ID, separated by a tab.

## Folder and Note References

Folder and note arguments accept either a name or a stable `x-coredata://...` ID. Prefer IDs when names can be duplicated or can change.

- `folder/list.sh` and `note/list.sh` return IDs.
- `folder/create.sh` and `note/create.sh` return the ID of the new object.
- `note/update.sh` replaces the body. Notes normally uses the first body line as the title, so use a note ID when the title may change and you need to find the note afterwards.
- When a folder argument is supplied, note IDs are resolved inside that folder.

## Output Contract

Tab-separated columns per command:

| Command | Columns |
| --- | --- |
| `folder/list.sh` | `id`, `name` |
| `folder/create.sh <name>` | `created`, `id` |
| `note/list.sh <folder\|id>` | `id`, `name`, `modification date` |
| `note/create.sh <folder\|id> <name> <bodyHTML>` | `created`, `id` |
| `note/search.sh <query>` | `name`, `modification date` |
| `note/count.sh <folder\|id>` | a single integer |
| `account/default-account.sh` | account name |
| `account/default-folder.sh` | folder name |
| `application/selection.sh` | selected note names, one per line (empty when nothing is selected) |
| `folder/get.sh <folder\|id> [property]` | `name:`, `id:`, `shared:`, `container:` lines, or one value when a property is named |
| `attachment/list.sh <folder\|id> <note\|id>` | `name` (or `<unnamed>`), `id`, 1-based `index` |
| `attachment/save.sh <folder\|id> <note\|id> <name\|index> <path>` | `saved` on success |

Dates come from AppleScript in the local system format, not ISO 8601.

`container:` is the parent of the folder, which can be another folder rather than an account. It is empty when Notes refuses to resolve it.

`attachment/list.sh` returns `<unnamed>` for attachments that have no filename, such as tables. `attachment/save.sh` accepts either the attachment name or its 1-based index. The path may be a full file path or an existing directory; when it is a directory, the attachment filename is appended. Attachments without a filename cannot be exported, and the command reports a non-file attachment error.

## Safety Boundaries

- Note delete and write actions must be explicit.
- Internal AppleScript files are not public API.
