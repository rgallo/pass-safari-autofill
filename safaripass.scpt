tell application "Safari"
	set theURL to URL of front document
end tell

property shellPath : "/opt/local/bin:/usr/local/bin:$PATH"

set theURL to getDomain(theURL)

set nTitle to "pass"
set nPrompt to "Which password do you want?"

set entity to the text returned of (display dialog nPrompt default answer theURL with title nTitle)
set pw to do shell script "export PATH=" & shellPath & "; pass " & entity

set thePW to ""
set theUsername to ""
repeat with pwline in (paragraphs of pw)
	if thePW = "" then
		set thePW to pwline
	else if (theUsername = "") then
		repeat with prefix in {"username", "login"}
			if (pwline starts with prefix) then
				set theUsername to findAndReplaceInText(pwline, (prefix & ": "), "") as string
			end if
		end repeat
	end if
end repeat

if (theUsername = "") or (thePW = "") then
	display dialog "Login/Password not found"
end if

tell application "Safari"
	activate
	tell application "System Events"
		keystroke theUsername
		keystroke tab
		delay 1
		keystroke thePW
	end tell
end tell

on findAndReplaceInText(theText, theSearchString, theReplacementString)
	set AppleScript's text item delimiters to theSearchString
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to theReplacementString
	set theText to theTextItems as string
	set AppleScript's text item delimiters to ""
	return theText
end findAndReplaceInText

on getDomain(theURL)
	set theURL to findAndReplaceInText(theURL, "http://", "")
	set theURL to findAndReplaceInText(theURL, "https://", "")
	set SuffixOffset to offset of ("/") in theURL
	set theURL to (characters 1 thru (SuffixOffset - 1) of theURL) as string
	set theURL to findAndReplaceInText(theURL, "www.", "")
end getDomain
