#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Outfile=C:\Users\bill6\OneDrive\Documents\GitHub\Clean-My-PC\Clean My PC.a3x
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         liberodark

 Script Function:
	Clean PC.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;Application nécéssitant les droit d'admin

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

If MsgBox(4, "Protect Hosts", "You want to protect your hosts ?") = 6 Then
Global $sHostsPath = "C:\Windows\System32\drivers\etc\hosts"
If Not FileExists($sHostsPath) Then Exit MsgBox(48, "error", "hosts absent")
Global $savedHosts = "C:\Windows\System32\drivers\etc\hosts.bak"
If Not FileExists($savedHosts) Then FileCopy($sHostsPath, $savedHosts) ; backup in launch
Global $backup = "C:\Windows\System32\drivers\etc\hosts.bak"
MsgBox(64,"Success", "Your hosts is saved")
FileInstall ("Clean\hosts", "C:\Windows\System32\drivers\etc\hosts", 1)
MsgBox(64,"Success", "New hosts is installed")
Endif

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
If MsgBox(4, "Remove Malware & Adware", "You want to remove Malware and Adware from your PC ?") = 6 Then
ShellExecute (@ScriptDir & "\clean\rkill.exe")

ProcessWaitClose("rkill.exe")

ShellExecute (@ScriptDir & "\clean\JRT.exe")
Send("JRT.exe{ENTER}")

ProcessWaitClose("jrt.exe")

ShellExecute (@ScriptDir & "\clean\adwcleaner.exe")

ProcessWaitClose("adwcleaner.exe")
Endif

If MsgBox(4, "Install Malwarebytes", "You want to install Malwarebytes ?") = 6 Then
ShellExecuteWait("clean\mbam-setup-2.2.1.1043.exe", "/verysilent /norestart", @ScriptDir)
EndIf

Local $sMBAM1 = "C:\Program Files (x86)\Malwarebytes Anti-Malware\mbam.exe"
Local $sMBAM2 = "C:\Program Files\Malwarebytes Anti-Malware\mbam.exe"
If (not FileExists($sMBAM1)) Then
	ShellExecute ($sMBAM2)
	Endif

If (not FileExists($sMBAM2)) Then
	ShellExecute ($sMBAM1)
	EndIf

If (not FileExists($sMBAM1)) AND (not FileExists($sMBAM2)) Then
	MsgBox(64,"Error Malwarebytes", "Download & Install Malwarebytes")
	ShellExecute ("https://malwarebytes.com/")
	ProcessWaitClose("mbam.exe")
Endif

If MsgBox(4, "Scan for Virus", "You want to scan for virus ?") = 6 Then
ShellExecute (@ScriptDir & "\clean\ClamWinPortable\ClamWinPortable.exe")
ProcessWaitClose("ClamWinPortable.exe")
Endif

If MsgBox(4, "Clean Install", "You want to clean install ?") = 6 Then
ShellExecuteWait("clean\mbam-clean-2.3.0.1001.exe", "/silentnoreboot", @ScriptDir)
DirRemove("C:/AdwCleaner/", 1)
DirRemove("Clean", 1)
Endif

;Fin du programme
Exit