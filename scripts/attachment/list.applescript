-- List attachments in a note. argv: folderName noteName
on run argv
	if (count of argv) < 2 then
		return "Usage: list.applescript <folder> <noteName>"
	end if
	set folderName to item 1 of argv
	set noteName to item 2 of argv

	tell application "Notes"
		set n to first note of folder folderName whose name is noteName
		set atts to attachments of n
		set output to ""
		repeat with a in atts
			set output to output & (name of a) & tab & (id of a) & linefeed
		end repeat
		return output
	end tell
end run
