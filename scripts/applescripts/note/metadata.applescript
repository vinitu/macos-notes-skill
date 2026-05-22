-- Get note metadata. argv: folderName noteName
on run argv
	if (count of argv) < 2 then
		return "Usage: metadata.applescript <folder> <noteName>"
	end if
	set folderName to item 1 of argv
	set noteName to item 2 of argv

	tell application "Notes"
		set n to first note of folder folderName whose name is noteName
		set output to "Name: " & (name of n) & linefeed
		set output to output & "Created: " & (creation date of n) & linefeed
		set output to output & "Modified: " & (modification date of n) & linefeed
		set output to output & "ID: " & (id of n)
		return output
	end tell
end run
