-- Create a folder. argv: folderName
-- Returns: created TAB folderId
on run argv
	if (count of argv) < 1 then
		return "Usage: create.applescript <folderName>"
	end if
	set folderName to item 1 of argv

	tell application "Notes"
		set newFolder to make new folder with properties {name:folderName}
		return "created" & tab & (id of newFolder)
	end tell
end run
