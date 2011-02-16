property fileTypes : {"com.apple.application", "com.apple.package", "com.apple.bundle"}
property extList : {"app"}
set fileName to choose file of type fileTypes with prompt "Select an Application:"
set certPattern to getCertPattern()
doResign(fileName, certPattern)

return

on open of these_items -- "open" handler triggered by drag'n'drop launches
	set certPattern to getCertPattern()
	repeat with i from 1 to the count of these_items
		set this_item to (item i of these_items)
		set the item_info to info for this_item
		if (the name extension of the item_info is in extList) then		
			doResign(this_item, certPattern)
		end if
	end repeat
end open

on getCertPattern()
	
	set dialogResult to display dialog Â
		"Enter signing identity:" with title "Signing Identity" buttons {"Cancel", "OK"} Â
		default button "OK" cancel button Â
		"Cancel" default answer "iPhone Developer"
	
	return text returned of dialogResult
	
end getCertPattern

on doResign(appName, cert)
	set appName to POSIX path of appName
	set appName to "\"" & appName & "\""
	set command to "/usr/bin/codesign -f -s \"" & cert & "\" " & appName as string
	
	local cmdResult
	local titleString
	
	set errorOccurred to false
	try
		do shell script command
	on error errText
		set errorOccurred to true
	end try
	
	if errorOccurred is equal to false then
		set cmdResult to "Successfully resigned app at " & appName
		set titleString to "Success"
	else
		set titleString to "Error"
		set cmdResult to errText
	end if
	
	display dialog cmdResult with title titleString buttons {"OK"} default button "OK" as string
end doResign