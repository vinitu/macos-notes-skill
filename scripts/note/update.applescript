-- Replace note body. argv: folderName noteName newBodyHTML
on run argv
	if (count of argv) < 3 then
		return "Usage: update.applescript <folder> <noteName> <newBodyHTML>"
	end if
	set folderName to item 1 of argv
	set noteName to item 2 of argv
	set newBody to item 3 of argv

	tell application "Notes"
		set n to first note of folder folderName whose name is noteName
		set body of n to newBody
	end tell
	return "updated"
end run
