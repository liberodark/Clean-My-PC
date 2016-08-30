#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=C:\Users\bill6\OneDrive\Documents\GitHub\Clean-My-PC\Clean My PC.exe
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         liberodark

 Script Function:
	Clean PC.

#ce ----------------------------------------------------------------------------

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
; save & install hosts

If MsgBox(4, "Protect Hosts", "You want to protect your hosts ?") = 6 Then
Global $sHostsPath = "C:\Windows\System32\drivers\etc\hosts"
If Not FileExists($sHostsPath) Then Exit MsgBox(48, "error", "hosts absent")
Global $savedHosts = "C:\Windows\System32\drivers\etc\hosts.bak"
If Not FileExists($savedHosts) Then FileCopy($sHostsPath, $savedHosts) ; backup in launch
Global $backup = "C:\Windows\System32\drivers\etc\hosts.bak"
FileInstall ("Clean\hosts", "C:\Windows\System32\drivers\etc\hosts", 1)
MsgBox(64,"Success", "New hosts is installed")
Endif

; ==================
;Select your Program

If MsgBox(4, "Remove Process", "You want to launch RKill ?") = 6 Then
ShellExecute (@ScriptDir & "\clean\rkill.exe")
ProcessWaitClose("rkill.exe")
Endif

If MsgBox(4, "Remove Process", "You want to launch JRT ?") = 6 Then
ShellExecute (@ScriptDir & "\clean\JRT.exe")
ProcessWaitClose("jrt.exe")
Endif

If MsgBox(4, "Remove Malware & Adware", "You want to scan for remove Malware and Adware from your PC ?") = 6 Then
ShellExecute (@ScriptDir & "\clean\adwcleaner.exe")

ProcessWaitClose("adwcleaner.exe")

ShellExecute (@ScriptDir & "\clean\ZHPCleaner.exe")

ProcessWaitClose("ZHPCleaner.exe")

ShellExecute (@ScriptDir & "\clean\RogueKiller.exe")

ProcessWaitClose("RogueKiller.exe")
Endif

; ==================
; Install Malwarebytes

If MsgBox(4, "Install Malwarebytes", "You want to install Malwarebytes ?") = 6 Then
ShellExecuteWait("clean\mbam-setup-2.2.1.1043.exe", "/verysilent /norestart", @ScriptDir)
EndIf

Local $sMBAM1 = "C:\Program Files (x86)\Malwarebytes Anti-Malware\mbam.exe"
Local $sMBAM2 = "C:\Program Files\Malwarebytes Anti-Malware\mbam.exe"

If FileExists($sMBAM1) Then      ; check $sMBAM1
        ShellExecuteWait($sMBAM1)
        ProcessWaitClose("mbam.exe")
ElseIf FileExists($sMBAM2) Then   ; check $sMBAM2
        ShellExecuteWait($sMBAM2)
        ProcessWaitClose("mbam.exe")
Else    ; And ...
    MsgBox(64,"Error Malwarebytes", "Download & Install Malwarebytes")
    ShellExecute ("https://malwarebytes.com/")
Endif

If MsgBox(4, "Scan for Virus", "You want to scan for virus ?") = 6 Then
ShellExecute (@ScriptDir & "\clean\ClamWinPortable\ClamWinPortable.exe")
ProcessWaitClose("ClamWinPortable.exe")
Endif


; ==================
; Clean Install

If MsgBox(4, "Clean Install", "You want to clean install ?") = 6 Then
ShellExecuteWait("clean\mbam-clean-2.3.0.1001.exe", "/silentnoreboot", @ScriptDir)
DirRemove("C:/AdwCleaner/", 1)
DirRemove("Clean", 1)
Endif

Exit