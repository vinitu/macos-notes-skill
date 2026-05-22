-- Get selected note names (selection in Notes UI). One per line.
on run argv
	tell application "Notes"
		set sel to selection
		set output to ""
		repeat with n in sel
			set output to output & (name of n) & linefeed
		end repeat
		return output
	end tell
end run
