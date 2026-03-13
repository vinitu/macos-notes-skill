# macOS Notes Skill

This repo stores a skill for Apple Notes.app integration on macOS via AppleScript (`osascript`).

## Installation

Install with `skills.sh`:

```bash
skills.sh add vinitu/macos-notes-skill
```

If you use the npm installer instead:

```bash
npx skills add vinitu/macos-notes-skill
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

```bash
# List all folders
osascript -e 'tell application "Notes" to return name of every folder'

# List notes in a folder
osascript -e 'tell application "Notes" to return name of every note of folder "Notes"'

# Create a note
osascript -e 'tell application "Notes" to tell folder "Notes" to make new note with properties {name:"My Note", body:"<p>Hello</p>"}'

# Search notes
osascript -e 'tell application "Notes" to return name of every note whose plaintext contains "search term"'
```

For the full command set and examples, see `SKILL.md`.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Notes got an error: Can't get folder" | Folder name is case-sensitive; check exact name |
| "Notes got an error: Can't get note" | Note does not exist; verify name or ID |
| AppleScript timeout | Notes.app may be syncing; wait and retry |
| Permission denied | Grant Automation access to terminal in System Settings |
