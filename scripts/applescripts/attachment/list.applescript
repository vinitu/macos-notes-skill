-- List attachments in a note. argv: folderName|folderId noteName|noteId
-- One line per attachment: name (or <unnamed>) TAB id TAB 1-based index
on run argv
	if (count of argv) < 2 then
		return "Usage: list.applescript <folderName|folderId> <noteName|noteId>"
	end if
	set folderSpec to item 1 of argv
	set noteSpec to item 2 of argv

	tell application "Notes"
		set f to missing value
		try
			set f to folder folderSpec
		end try
		if f is missing value then
			set f to first folder whose id is folderSpec
		end if
		set n to missing value
		try
			set n to first note of f whose name is noteSpec
		end try
		if n is missing value then
			set n to first note of f whose id is noteSpec
		end if
		set atts to attachments of n
		set output to ""
		set i to 0
		repeat with a in atts
			set i to i + 1
			set attName to name of a
			if attName is missing value then set attName to "<unnamed>"
			set output to output & attName & tab & (id of a) & tab & i & linefeed
		end repeat
		return output
	end tell
end run
