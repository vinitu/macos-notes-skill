-- Get note content and metadata. argv: folderName noteName|noteId [plaintext|body]
-- Output includes password protected, shared (sdef)
on run argv
	if (count of argv) < 2 then
		return "Usage: get.applescript <folder> <noteName|noteId> [plaintext|body]"
	end if
	set folderName to item 1 of argv
	set searchVal to item 2 of argv
	set outputMode to "plaintext"
	if (count of argv) ≥ 3 then set outputMode to item 3 of argv

	tell application "Notes"
		set n to missing value
		try
			set n to first note of folder folderName whose name is searchVal
		end try
		if n is missing value then
			try
				set n to first note whose id is searchVal
			end try
		end if
		if n is missing value then
			return "Note not found"
		end if
		if outputMode is "body" then
			return body of n
		end if
		set output to "plaintext: " & (plaintext of n) & linefeed
		set output to output & "password protected: " & (password protected of n) & linefeed
		set output to output & "shared: " & (shared of n)
		return output
	end tell
end run
