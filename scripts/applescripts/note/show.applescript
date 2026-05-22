-- Show account, folder, note, or attachment in Notes UI. argv: type name
-- type: account | folder | note | attachment
on run argv
	if (count of argv) < 2 then
		return "Usage: show.applescript <account|folder|note|attachment> <name>"
	end if
	set itemType to item 1 of argv
	set itemName to item 2 of argv

	tell application "Notes"
		if itemType is "account" then
			show (account itemName)
		else if itemType is "folder" then
			show (folder itemName)
		else if itemType is "note" then
			show (first note whose name is itemName)
		else if itemType is "attachment" then
			show (first attachment whose name is itemName)
		else
			return "Unknown type: " & itemType
		end if
	end tell
	return "shown"
end run
