-- Get folder properties (shared, container). argv: folderName [property]
on run argv
	if (count of argv) < 1 then
		return "Usage: get.applescript <folderName> [property]"
	end if
	set folderName to item 1 of argv
	set propName to ""
	if (count of argv) ≥ 2 then set propName to item 2 of argv

	tell application "Notes"
		set f to folder folderName
		if propName is "shared" then
			return shared of f
		else if propName is "container" then
			return name of container of f
		else if propName is "name" then
			return name of f
		else if propName is "id" then
			return id of f
		else
			set output to "name: " & (name of f) & linefeed
			set output to output & "id: " & (id of f) & linefeed
			set output to output & "shared: " & (shared of f) & linefeed
			set output to output & "container: " & (name of container of f)
			return output
		end if
	end tell
end run
