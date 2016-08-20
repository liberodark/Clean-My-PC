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
#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <ProgressConstants.au3>

;Lancement du prog d'installation
ShellExecute (@ScriptDir & "\clean\rkill.exe")

ProcessWaitClose("rkill.exe")

ShellExecute (@ScriptDir & "\clean\JRT.exe")
Send("{ENTER}")

ProcessWaitClose("jrt.exe")

ShellExecute (@ScriptDir & "\clean\adwcleaner_6.000.exe")

;Récupération du "handler" de la fenêtre
$Hndl = WinGetHandle("- AdwCleaner - Conditions d'utilisation -")

;Fournir le focus à Adwcleaner
WinActivate($Hndl)

;Attente de la fenêtre principal du programme
WinWaitActive ("- AdwCleaner - v6.000 - Toolslib -")

;Lancer la fonction de scan
Send("{TAB}")
Send("{ENTER}")

;Fin du programme
Exit