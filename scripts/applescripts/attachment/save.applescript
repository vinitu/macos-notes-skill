-- Save (export) attachment to path. argv: folderName noteName attachmentName path
on run argv
	if (count of argv) < 4 then
		return "Usage: save.applescript <folder> <noteName> <attachmentName> <path>"
	end if
	set folderName to item 1 of argv
	set noteName to item 2 of argv
	set attName to item 3 of argv
	set savePath to item 4 of argv
	set pathFile to POSIX file savePath

	tell application "Notes"
		set n to first note of folder folderName whose name is noteName
		set a to first attachment of n whose name is attName
		save a in pathFile
	end tell
	return "saved"
end run
