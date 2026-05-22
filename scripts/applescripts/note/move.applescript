-- Move note to another folder. argv: folderName noteName targetFolderName
on run argv
	if (count of argv) < 3 then
		return "Usage: move.applescript <folder> <noteName> <targetFolder>"
	end if
	set folderName to item 1 of argv
	set noteName to item 2 of argv
	set targetFolder to item 3 of argv

	tell application "Notes"
		set n to first note of folder folderName whose name is noteName
		move n to folder targetFolder
	end tell
	return "moved"
end run
