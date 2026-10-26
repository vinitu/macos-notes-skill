-- Create a note. argv: folderName|folderId name bodyHTML
-- Returns: created TAB noteId
on run argv
	if (count of argv) < 3 then
		return "Usage: create.applescript <folderName|folderId> <name> <bodyHTML>"
	end if
	set folderName to item 1 of argv
	set noteName to item 2 of argv
	set bodyHTML to item 3 of argv

	tell application "Notes"
		set f to missing value
		try
			set f to folder folderName
		end try
		if f is missing value then
			set f to first folder whose id is folderName
		end if
		set newNote to make new note at f with properties {name:noteName, body:bodyHTML}
		return "created" & tab & (id of newNote)
	end tell
end run
