-- Create a note. argv: folderName name bodyHTML
on run argv
	if (count of argv) < 3 then
		return "Usage: create.applescript <folder> <name> <bodyHTML>"
	end if
	set folderName to item 1 of argv
	set noteName to item 2 of argv
	set bodyHTML to item 3 of argv

	tell application "Notes"
		tell folder folderName
			make new note with properties {name:noteName, body:bodyHTML}
		end tell
	end tell
	return "created"
end run
