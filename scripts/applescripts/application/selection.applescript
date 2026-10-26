-- Get selected note names (selection in Notes UI). One per line.
on run argv
	tell application "Notes"
		set sel to selection
		set output to ""
		repeat with n in sel
			set noteName to name of n
			if noteName is missing value then set noteName to "<unnamed>"
			set output to output & noteName & linefeed
		end repeat
		return output
	end tell
end run
