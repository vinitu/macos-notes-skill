-- Save (export) attachment to a file or directory.
-- argv: folderName|folderId noteName|noteId attachmentName|index path
on run argv
	if (count of argv) < 4 then
		return "Usage: save.applescript <folderName|folderId> <noteName|noteId> <attachmentName|index> <path>"
	end if
	set folderSpec to item 1 of argv
	set noteSpec to item 2 of argv
	set attSpec to item 3 of argv
	set savePath to item 4 of argv

	tell application "Notes"
		set f to missing value
		try
			set f to folder folderSpec
		end try
		if f is missing value then
			set f to first folder whose id is folderSpec
		end if
		set n to missing value
		try
			set n to first note of f whose name is noteSpec
		end try
		if n is missing value then
			set n to first note of f whose id is noteSpec
		end if
		set a to missing value
		try
			set a to first attachment of n whose name is attSpec
		end try
		if a is missing value then
			try
				set a to attachment (attSpec as integer) of n
			end try
		end if
		if a is missing value then error "Attachment not found"
		if (name of a) is missing value then error "Attachment has no filename and cannot be exported; tables and other non-file attachments are not supported"

		if savePath ends with "/" then set savePath to text 1 thru -2 of savePath
		set isDirectory to false
		try
			do shell script "test -d " & quoted form of savePath
			set isDirectory to true
		end try
		if isDirectory then
			set savePath to savePath & "/" & (name of a)
		end if

		save a in (POSIX file savePath)
	end tell
	return "saved"
end run
