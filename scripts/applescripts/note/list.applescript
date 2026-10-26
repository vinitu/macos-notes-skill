-- List notes in a folder. argv: folderName|folderId
-- One line per note: id TAB name TAB modification date
on run argv
	if (count of argv) < 1 then
		return "Usage: list.applescript <folderName|folderId>"
	end if
	set folderSpec to item 1 of argv

	tell application "Notes"
		set targetFolder to missing value
		try
			set targetFolder to folder folderSpec
		end try
		if targetFolder is missing value then
			set targetFolder to first folder whose id is folderSpec
		end if
		set output to ""
		repeat with n in notes of targetFolder
			set output to output & (id of n) & tab & (name of n) & tab & (modification date of n) & linefeed
		end repeat
		return output
	end tell
end run
