-- Move note to another folder. argv: folderName|folderId noteName|noteId targetFolderName|targetFolderId
on run argv
	if (count of argv) < 3 then
		return "Usage: move.applescript <folderName|folderId> <noteName|noteId> <targetFolderName|targetFolderId>"
	end if
	set folderName to item 1 of argv
	set noteName to item 2 of argv
	set targetFolder to item 3 of argv

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
		set target to missing value
		try
			set target to folder targetFolder
		end try
		if target is missing value then
			set target to first folder whose id is targetFolder
		end if
		move n to target
	end tell
	return "moved"
end run
