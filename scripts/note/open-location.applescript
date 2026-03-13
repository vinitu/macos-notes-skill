-- Open a note URL (notes:// or x-apple-note://). argv: url
on run argv
	if (count of argv) < 1 then
		return "Usage: open-location.applescript <url>"
	end if
	set urlStr to item 1 of argv

	tell application "Notes"
		open note location urlStr
	end tell
	return "opened"
end run
