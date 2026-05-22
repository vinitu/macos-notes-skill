-- Create a folder. argv: folderName
on run argv
	if (count of argv) < 1 then
		return "Usage: create.applescript <folderName>"
	end if
	set folderName to item 1 of argv

	tell application "Notes"
		make new folder with properties {name:folderName}
	end tell
	return "created"
end run
