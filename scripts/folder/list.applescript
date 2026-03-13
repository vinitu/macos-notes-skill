-- List all note folders. One line per folder: id TAB name
tell application "Notes"
	set output to ""
	repeat with f in folders
		set output to output & (id of f) & tab & (name of f) & linefeed
	end repeat
	return output
end tell
