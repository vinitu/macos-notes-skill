-- Search notes by plaintext content. argv: query
on run argv
	if (count of argv) < 1 then
		return "Usage: search.applescript <query>"
	end if
	set query to item 1 of argv

	tell application "Notes"
		set matches to every note whose plaintext contains query
		set output to ""
		repeat with n in matches
			set output to output & (name of n) & tab & (modification date of n) & linefeed
		end repeat
		return output
	end tell
end run
