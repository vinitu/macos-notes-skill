-- Get note metadata. argv: folderName|folderId noteName|noteId
on run argv
	if (count of argv) < 2 then
		return "Usage: metadata.applescript <folderName|folderId> <noteName|noteId>"
	end if
	set folderName to item 1 of argv
	set noteName to item 2 of argv

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
		set output to "Name: " & (name of n) & linefeed
		set output to output & "Created: " & (creation date of n) & linefeed
		set output to output & "Modified: " & (modification date of n) & linefeed
		set output to output & "ID: " & (id of n)
		return output
	end tell
end run
