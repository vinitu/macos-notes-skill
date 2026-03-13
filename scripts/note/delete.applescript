-- Delete a note. argv: folderName noteName
on run argv
	if (count of argv) < 2 then
		return "Usage: delete.applescript <folder> <noteName>"
	end if
	set folderName to item 1 of argv
	set noteName to item 2 of argv

	tell application "Notes"
		set n to first note of folder folderName whose name is noteName
		delete n
	end tell
	return "deleted"
end run
