#Requires AutoHotkey v2.0


; --------- FOR COPYING AND PASTING BETWEEN VMs

; Get the current day of the week (1=Sunday, 2=Monday, ..., 7=Saturday)
wday := A_WDay

; Convert so Monday = 1, ..., Sunday = 7
mondayBasedWDay := wday = 1 ? 7 : wday - 1

dayFolder:= "0" mondayBasedWDay "_" StrUpper(A_DDDD)

; Set the crackle path, make sure it exists
rootPath := "\\nyengcrackle\public1\" dayFolder

; If not throw an error and exit
if not DirExist(rootPath) {
	Msgbox "Something is wrong, can't find the crackle server"
	ExitApp
	}

; A function to make the paths
makePaths(id) {
	Global fullTxtPath:= rootPath "\" id "\" id "_clipboard.txt"
	; Create the folder
	Global folderPath:= rootPath "\" id
    	result := MsgBox("Confirm this crackle folder is correct, if not this program will close: `n`n" dayFolder "\" id, "Crackle Folder Confirmation", "YesNo")
   	; If the user says the folder is wrong, close AHK
	if not result = "Yes" {
		ExitApp
		} else {
		; Otherwise create the folder path
				if not DirExist(folderPath) {
				DirCreate(folderPath)
       		}
		}
}

idFilePath := A_ScriptDir "\id.txt"

if FileExist(idFilePath) {
    hubID := Trim(FileRead(idFilePath))
    makePaths(hubID)
} else {
    input := InputBox("Enter your Hub ID to make a new folder on the Crackle server:", "Create Folder on Crackle")
    if input.Result != "OK" || Trim(input.Value) = "" {
        MsgBox "No ID entered. Exiting script."
        ExitApp
    }
    hubID := Trim(input.Value)
	FileAppend(hubID, idFilePath)
    makePaths(hubID)
}


Scrolllock:: {

	; Copy selected text to clipboard
	Send "^c"
	Sleep 200  ; Give clipboard time to update


	; Get clipboard contents
	clipText := A_Clipboard

	; Save clipboard to file
	file := FileOpen(fullTxtPath, "w")
	file.Write(A_Clipboard)
	file.Close()


	; Confirm it worked - debug only
	; MsgBox clipText " saved to: " fullTxtPath
}

Pause:: {
	; Grab the contents from the folder, making sure it exists first
	if FileExist(fullTxtPath) {
	A_Clipboard := FileRead(fullTxtPath)	
	Send "^v"
} else {
	MsgBox "There's nothing on the clipboard.  Try copying first!"
    }

}
