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
;RunWait("net stop Dnscache")
;RunWait("sc config Dnscache start= disable")
;RunWait("sc config Dnscache start= enable")
;RunWait("sc config Dnscache start= demand")
Local $sFilePath = @ScriptDir & "hosts.txt"
Local $hDownload = InetGet("https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
Do
Sleep(250)
Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)
MsgBox(64,"Success", "New hosts is Updated")
FileCopy ("hosts.txt", "C:\Windows\System32\drivers\etc\hosts", 1)
FileDelete("C:\Windows\System32\drivers\etc\hosts.tmp")
RunWait("ipconfig /flushdns")
MsgBox(64,"Success", "New hosts is installed")
Endif

Exit