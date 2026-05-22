-- Get default folder name for an account. argv: [accountName] (default account if omitted)
on run argv
	tell application "Notes"
		if (count of argv) ≥ 1 then
			set acc to account (item 1 of argv)
		else
			set acc to default account
		end if
		return name of default folder of acc
	end tell
end run
