-- Get attachment metadata. argv: folderName noteName attachmentName|index
on run argv
	if (count of argv) < 3 then
		return "Usage: get.applescript <folder> <noteName> <attachmentName|index>"
	end if
	set folderName to item 1 of argv
	set noteName to item 2 of argv
	set searchVal to item 3 of argv

	tell application "Notes"
		set n to first note of folder folderName whose name is noteName
		set a to missing value
		try
			set a to first attachment of n whose name is searchVal
		end try
		if a is missing value then
			try
				set a to attachment (searchVal as integer) of n
			end try
		end if
		if a is missing value then
			return "Attachment not found"
		end if
		set output to "name: " & (name of a) & linefeed
		set output to output & "id: " & (id of a) & linefeed
		set output to output & "creation date: " & (creation date of a) & linefeed
		set output to output & "modification date: " & (modification date of a) & linefeed
		set output to output & "shared: " & (shared of a)
		return output
	end tell
end run
