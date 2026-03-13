---
name: macos-notes
description: Create, read, update, and organize notes in Apple Notes.app on macOS. Use for note-taking, lists, drafts, or any text the user wants to save. Triggers on queries about notes, writing something down, saving information, or Apple Notes.
---

# macOS Notes Integration

Create, read, update, delete, and search notes in Apple Notes.app using AppleScript (`osascript`) on macOS.

## How It Works

All operations use `osascript -e 'tell application "Notes" ... end tell'`. Notes.app stores data in iCloud (or local accounts) and syncs across Apple devices automatically.

## Commands

### List All Folders

```bash
osascript -e '
tell application "Notes"
  set output to ""
  repeat with f in folders
    set output to output & id of f & tab & name of f & linefeed
  end repeat
  return output
end tell'
```

### List Notes in a Folder

```bash
osascript -e '
tell application "Notes"
  set output to ""
  repeat with n in notes of folder "Notes"
    set output to output & id of n & tab & name of n & tab & modification date of n & linefeed
  end repeat
  return output
end tell'
```

### Read a Note by Name

```bash
osascript -e '
tell application "Notes"
  set n to first note of folder "Notes" whose name is "Shopping List"
  return plaintext of n
end tell'
```

### Read a Note by ID

```bash
osascript -e '
tell application "Notes"
  set n to first note whose id is "x-coredata://XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/ICNote/p123"
  return plaintext of n
end tell'
```

### Create a Note

```bash
osascript -e '
tell application "Notes"
  tell folder "Notes"
    make new note with properties {name:"Meeting Notes", body:"<h1>Meeting Notes</h1><p>Action items go here.</p>"}
  end tell
end tell'
```

The `body` property accepts HTML. Use `<h1>`, `<p>`, `<ul>`, `<li>`, `<b>`, `<i>`, `<br>` tags for formatting.

### Update a Note (Replace Body)

```bash
osascript -e '
tell application "Notes"
  set n to first note of folder "Notes" whose name is "Meeting Notes"
  set body of n to "<h1>Meeting Notes</h1><p>Updated content here.</p>"
end tell'
```

### Append to a Note

```bash
osascript -e '
tell application "Notes"
  set n to first note of folder "Notes" whose name is "Shopping List"
  set currentBody to body of n
  set body of n to currentBody & "<p>New item added</p>"
end tell'
```

### Delete a Note

```bash
osascript -e '
tell application "Notes"
  set n to first note of folder "Notes" whose name is "Old Note"
  delete n
end tell'
```

**Warning**: Deleted notes go to the "Recently Deleted" folder and are permanently removed after 30 days.

### Search Notes by Text

```bash
osascript -e '
tell application "Notes"
  set output to ""
  set matches to every note whose plaintext contains "search term"
  repeat with n in matches
    set output to output & name of n & tab & modification date of n & linefeed
  end repeat
  return output
end tell'
```

### Create a Folder

```bash
osascript -e '
tell application "Notes"
  make new folder with properties {name:"Work"}
end tell'
```

### Move a Note to Another Folder

```bash
osascript -e '
tell application "Notes"
  set n to first note of folder "Notes" whose name is "Project Plan"
  move n to folder "Work"
end tell'
```

### Get Note Metadata

```bash
osascript -e '
tell application "Notes"
  set n to first note of folder "Notes" whose name is "Meeting Notes"
  set output to "Name: " & name of n & linefeed
  set output to output & "Created: " & creation date of n & linefeed
  set output to output & "Modified: " & modification date of n & linefeed
  set output to output & "ID: " & id of n
  return output
end tell'
```

### Count Notes in a Folder

```bash
osascript -e '
tell application "Notes"
  return count of notes of folder "Notes"
end tell'
```

## Best Practices

### HTML Formatting

Notes.app stores content as HTML. When creating or updating notes:
- Use `<h1>` for the title (first line becomes the note name automatically).
- Use `<p>` for paragraphs, `<br>` for line breaks.
- Use `<ul><li>` for bullet lists, `<ol><li>` for numbered lists.
- Use `<b>` for bold, `<i>` for italic.
- Use `<a href="...">` for links.

### Note Naming

- The note `name` is derived from the first line of the body.
- Setting `name` explicitly in `make new note` sets the first line.
- When searching by name, use exact match or `contains` for partial match.

### Performance

- For large accounts with many notes, limit searches to specific folders.
- Use `whose name is` or `whose id is` for direct lookups instead of iterating.

### Data Safety

- Always confirm with the user before deleting notes.
- Prefer appending over replacing when adding content.
- Back up important notes before bulk operations.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Notes got an error: Can't get folder" | Folder name is case-sensitive; check exact name |
| "Notes got an error: Can't get note" | Note does not exist; verify name or ID |
| AppleScript timeout | Notes.app may be syncing; wait and retry |
| Formatting lost on update | Ensure body uses HTML tags, not plain text |
| Permission denied | Grant Automation access to terminal in System Settings |

## Technical Notes

- Uses AppleScript via `osascript` (no private APIs).
- Notes.app must be present on the system (ships with macOS).
- Works with iCloud, Gmail, and local ("On My Mac") accounts.
- Requires macOS 10.11+ (El Capitan or later).
- Automation permission required (System Settings -> Privacy & Security -> Automation).
