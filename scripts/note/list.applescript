-- List notes in a folder. argv: [folderName] (default: first folder)
-- One line per note: id TAB name TAB modification date
on run argv
	tell application "Notes"
		set flds to folders
		if (count of flds) is 0 then
			return ""
		end if
		if (count of argv) ≥ 1 then
			set targetFolder to folder (item 1 of argv)
		else
			set targetFolder to item 1 of flds
		end if
		set output to ""
		repeat with n in notes of targetFolder
			set output to output & (id of n) & tab & (name of n) & tab & (modification date of n) & linefeed
		end repeat
		return output
	end tell
end run
