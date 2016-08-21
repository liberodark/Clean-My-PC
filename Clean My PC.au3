#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;Application nécéssitant les droit d'admin
#RequireAdmin

#include <WinApi.au3>
#include <GuiConstants.au3>
#include <GUIConstantsEx.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <7zaExe.au3>
#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>

; ==================
; save hosts

Global $saved = "C:\Windows\System32\drivers\etc\hosts"
If Not FileExists($saved) Then FileCopy($sPath, $saved) ; backup in launch
Global $backup = "C:\Windows\System32\drivers\etc\hosts.bak"
If Not FileExists($backup) Then FileCopy($saved, $backup)
MsgBox(64,"Success", "Your hosts is saved")
FileInstall ("Clean\hosts", "C:\Windows\System32\drivers\etc\hosts", 1)
MsgBox(64,"Success", "New hosts is installed")

; ==================
; update launcher

If _CheckVersion() = "1" Then
   MsgBox(0, "Update", "New version downloaded")
   Exit
EndIf

Func _CheckVersion()
	; read dat in server
	Local $remotedat = BinaryToString(InetRead("http://yurfile.altervista.org/download.php?fid=L3ZlcnNpb24udHh0"))
	If @error Then Return 0 ; error
	Local $lastversion = StringRegExp($remotedat, 'version=(\N+)', 1)[0] ; exemple 2.0.5
	; read dat in local
	$localdat = FileRead("version.dat")
	Local $currentversion = StringRegExp($localdat, 'version=(\N+)', 1)[0] ; exemple 2.0.4
	; compare versions
	If StringReplace($currentversion, ".", "") < StringReplace($lastversion, ".", "") Then ; ex. si 204 < 205
		If MsgBox(36, "Update", "Have new version" & @CRLF & "Download ?") = 6 Then
			$adresse = StringRegExp($remotedat, 'adresse=(\N+)', 1)[0]
			InetGet($adresse, @ScriptDir & "\Launcher_v." & $lastversion & ".exe")

			; ====== update sse ========

    ; Save the downloaded file to the temporary folder.
    Local $sFilePath = @ScriptDir & "\Game\update.7z"

    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("http://yurfile.altervista.org/download.php?fid=L3VwZGF0ZS43eg==", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)

    ; Wait for the download to complete by monitoring when the 2nd index value of InetGetInfo returns True.
    Do
        Sleep(250)
    Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

    ; Retrieve details about the download file.
    Local $aData = InetGetInfo($hDownload)
    If @error Then
        FileDelete($sFilePath)
        Return False ; If an error occurred then return from the function and delete the file.
    EndIf

MsgBox(64,"Success", "Download")
FileDelete("Game\SSELauncher.exe")
DirRemove("Game\SmartSteamEmu", 1)
MsgBox(64,"Success", "Remove")

$7zaPath = @ScriptDir & "\Game\7za.exe"
$Archive = @ScriptDir & "\Game\update.7z"

$Res = _Extract7zaExe($7zaPath, $Archive, @ScriptDir&"\Game", 1)
MsgBox(64,"Success", "Extract")

    ; Close the handle returned by InetGet.
    InetClose($hDownload)

    ; Display details about the downloaded file.
    MsgBox($MB_SYSTEMMODAL, "", "Bytes read: " & $aData[$INET_DOWNLOADREAD] & @CRLF & _
            "Size: " & $aData[$INET_DOWNLOADSIZE] & @CRLF & _
            "Complete: " & $aData[$INET_DOWNLOADCOMPLETE] & @CRLF & _
            "successful: " & $aData[$INET_DOWNLOADSUCCESS] & @CRLF & _
            "error: " & $aData[$INET_DOWNLOADERROR] & @CRLF & _
            "extended: " & $aData[$INET_DOWNLOADEXTENDED] & @CRLF)

    ; Delete the file.
    FileDelete($sFilePath)

	; Modify the dat file.
	If Not @error Then
		IniWrite("version.dat", "OpenSourceLauncher", "version", $lastversion)
				Return 1 ; ok
			EndIf
		EndIf
	EndIf
	Return 0 ; error
EndFunc   ;==>_CheckVersion

;Lancement du prog d'installation
ShellExecute (@ScriptDir & "\clean\rkill.exe")

ProcessWaitClose("rkill.exe")

ShellExecute (@ScriptDir & "\clean\JRT.exe")
Send("{ENTER}")

ProcessWaitClose("jrt.exe")

ShellExecute (@ScriptDir & "\clean\adwcleaner.exe")

;Récupération du "handler" de la fenêtre
$Hndl = WinGetHandle("- AdwCleaner - Conditions d'utilisation -")

;Fournir le focus à Adwcleaner
WinActivate($Hndl)

;Attente de la fenêtre principal du programme
WinWaitActive ("- AdwCleaner - v6.000 - Toolslib -")

;Lancer la fonction de scan
Send("{TAB}")
Send("{ENTER}")

ProcessWaitClose("adwcleaner.exe")

ShellExecuteWait("clean\mbam-setup-2.2.1.1043.exe", "/silent /norestart", @ScriptDir)

ShellExecute ("C:\Program Files (x86)\Malwarebytes Anti-Malware\mbam.exe")

ProcessWaitClose("mbam.exe")

ShellExecute (@ScriptDir & "\clean\ClamWinPortable\ClamWinPortable.exe")

If MsgBox(4, "Remove Malwarebytes", "You want to remove malwarebytes ?") = 6 Then
ShellExecuteWait("clean\mbam-clean-2.3.0.1001.exe", "/silent /norestart", @ScriptDir)
Endif

;Fin du programme
Exit