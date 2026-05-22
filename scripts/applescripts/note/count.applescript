-- Count notes in folder. argv: folderName
on run argv
	if (count of argv) < 1 then
		return "Usage: count.applescript <folder>"
	end if
	set folderName to item 1 of argv

	tell application "Notes"
		return (count of notes of folder folderName) as text
	end tell
end run
