-- Count notes in folder. argv: folderName|folderId
on run argv
	if (count of argv) < 1 then
		return "Usage: count.applescript <folderName|folderId>"
	end if
	set folderName to item 1 of argv

	tell application "Notes"
		set f to missing value
		try
			set f to folder folderName
		end try
		if f is missing value then
			set f to first folder whose id is folderName
		end if
		return (count of notes of f) as text
	end tell
end run
