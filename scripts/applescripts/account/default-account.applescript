-- Get default account name.
on run argv
	tell application "Notes"
		return name of default account
	end tell
end run
