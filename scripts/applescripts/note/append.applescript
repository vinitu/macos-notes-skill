-- Append HTML to note. argv: folderName|folderId noteName|noteId htmlFragment
on run argv
	if (count of argv) < 3 then
		return "Usage: append.applescript <folderName|folderId> <noteName|noteId> <htmlFragment>"
	end if
	set folderName to item 1 of argv
	set noteName to item 2 of argv
	set fragment to item 3 of argv

	tell application "Notes"
		set f to missing value
		try
			set f to folder folderName
		end try
		if f is missing value then
			set f to first folder whose id is folderName
		end if
		set n to missing value
		try
			set n to first note of f whose name is noteName
		end try
		if n is missing value then
			set n to first note of f whose id is noteName
		end if
		set currentBody to body of n
		set body of n to currentBody & fragment
	end tell
	return "appended"
end run
