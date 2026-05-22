-- Append HTML to note. argv: folderName noteName htmlFragment
on run argv
	if (count of argv) < 3 then
		return "Usage: append.applescript <folder> <noteName> <htmlFragment>"
	end if
	set folderName to item 1 of argv
	set noteName to item 2 of argv
	set fragment to item 3 of argv

	tell application "Notes"
		set n to first note of folder folderName whose name is noteName
		set currentBody to body of n
		set body of n to currentBody & fragment
	end tell
	return "appended"
end run
