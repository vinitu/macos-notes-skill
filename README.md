# macOS Notes Skill

This repo stores a skill for Apple Notes.app integration on macOS via AppleScript (`osascript`).

## Installation

```bash
npx skills add vinitu/macos-notes-skill
```

Or with [skills.sh](https://skills.sh):

```bash
skills.sh add vinitu/macos-notes-skill
```

## Scope

- List folders and notes in Apple Notes.app.
- Create, read, update, and delete notes.
- Search notes by text content.
- Organize notes into folders (create folders, move notes between them).
- Retrieve note metadata (creation date, modification date, ID).

## Prerequisites

- macOS 10.11+ (El Capitan or later) with Notes.app
- Automation permission granted to terminal (System Settings -> Privacy & Security -> Automation)

## How To Use

From the skill directory (or path where scripts are installed):

```bash
# List all note folders (id and name)
osascript scripts/folder/list.applescript
# List notes in folder "Notes"
osascript scripts/note/list.applescript "Notes"
# Create note in folder "Notes" with name and HTML body
osascript scripts/note/create.applescript "Notes" "My Note" "<p>Hello</p>"
# Search notes by plaintext content
osascript scripts/note/search.applescript "search term"
```

For the full command set and examples, see `SKILL.md` and scripts under `scripts/`.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Notes got an error: Can't get folder" | Folder name is case-sensitive; check exact name |
| "Notes got an error: Can't get note" | Note does not exist; verify name or ID |
| AppleScript timeout | Notes.app may be syncing; wait and retry |
| Permission denied | Grant Automation access to terminal in System Settings |
