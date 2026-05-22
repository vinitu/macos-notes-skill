# macOS Notes Skill

This repo stores an AI agent skill for Apple Notes.app on macOS.

The public interface is `scripts/commands`.
`scripts/applescripts` stores internal AppleScript backends and dictionary-aligned coverage.

## Installation

```bash
npx skills add vinitu/macos-notes-skill
```

Or with [skills.sh](https://skills.sh):

```bash
skills.sh add vinitu/macos-notes-skill
```

## Prerequisites

- macOS with Notes.app
- Automation permission granted to your terminal app

## Public Interface

Run skill actions with:

```bash
scripts/commands/<entity>/<action>.sh [args...]
```

## Backend Map

- `scripts/commands/account/*` → AppleScript in `scripts/applescripts/account/*`
- `scripts/commands/application/*` → AppleScript in `scripts/applescripts/application/*`
- `scripts/commands/attachment/*` → AppleScript in `scripts/applescripts/attachment/*`
- `scripts/commands/folder/*` → AppleScript in `scripts/applescripts/folder/*`
- `scripts/commands/note/*` → AppleScript in `scripts/applescripts/note/*`

## Command Surface

Account:

- `scripts/commands/account/default-account.sh`
- `scripts/commands/account/default-folder.sh`

Application:

- `scripts/commands/application/selection.sh`

Attachment:

- `scripts/commands/attachment/get.sh`
- `scripts/commands/attachment/list.sh`
- `scripts/commands/attachment/save.sh`

Folder:

- `scripts/commands/folder/create.sh`
- `scripts/commands/folder/get.sh`
- `scripts/commands/folder/list.sh`

Note:

- `scripts/commands/note/append.sh`
- `scripts/commands/note/count.sh`
- `scripts/commands/note/create.sh`
- `scripts/commands/note/delete.sh`
- `scripts/commands/note/get.sh`
- `scripts/commands/note/list.sh`
- `scripts/commands/note/metadata.sh`
- `scripts/commands/note/move.sh`
- `scripts/commands/note/open-location.sh`
- `scripts/commands/note/search.sh`
- `scripts/commands/note/show.sh`
- `scripts/commands/note/update.sh`

## Validation

```bash
make compile
make test
```
