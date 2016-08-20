#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=favicon256.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Excel.au3>
#include <GuiConstants.au3>
#include <GuiIPAddress.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
HotKeySet("{ENTER}", "_btnSubmit")


$fichier = @ScriptDir & "\clean\hosts.txt"
If FileExists($fichier) <> 1 Then
	msgbox(64,"ERREUR","Le fichier hosts.txt n'est pas présent dans "&@ScriptDir)	; Si le fichier n'existe pas, ERREUR
	Exit
EndIf

ProcessClose("Excel.exe")
_ExcelBookOpen($fichier)
$oExcel = ObjGet("","Excel.Application")
$oExcel.SheetsInNewWorkbook = 1
$oExcel.Visible = 0
$nbnom = 0
$nbpc = 0



while ($oExcel.Activesheet.Cells(2+$nbnom,1).Value)
 $nbnom = 1+$nbnom
WEnd

while ($oExcel.Activesheet.Cells(2+$nbpc,2).Value)
 $nbpc = 1+$nbpc
WEnd


if $nbnom <> $nbpc Then
	msgbox(0,"Erreur",'Un champ dans colonne "Utilisateur" ou colonne "PC" n'&"'"&'est pas saisie')
	Exit
elseif $nbnom = 0 or $nbpc = 0 Then
	msgbox(0,"Erreur","Aucun champs a été renseigné dans la collone Utilisateur ou PC")
	Exit
EndIf

    $Ipgui=GUICreate("IP", 249, 152)
	GUICtrlCreateLabel("Veuillez cliquer sur l'un des boutons :", 10, 10, 200, 17)
    $hIpgui = _GUICtrlIpAddress_Create($Ipgui, 25, 90, 200)
	$quit = GUICtrlCreateButton("Quitter", 140,120,80,25)
	$ok = GUICtrlCreateButton("OK", 35,120,80,25)
	GUISetState(@SW_SHOW)
while 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
		Case $quit
           Exit
	   Case $ok
		   $IP = _GUICtrlIpAddress_Get($hIPgui)
		   guidelete("IP")
		   ExitLoop
		Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
wend



    GUICreate("Nom", 249, 152)
	GUICtrlCreateLabel("Veuillez cliquer sur l'un des boutons :", 10, 10, 200, 17)
    $Namegui = GUICtrlCreateInput("", 25, 90)
	$quit = GUICtrlCreateButton("Quitter", 140,120,80,25)
	$ok = GUICtrlCreateButton("OK", 35,120,80,25)
	GUISetState(@SW_SHOW)
While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
		Case $quit
           Exit
		Case $ok
			$dns = GUICtrlRead($Namegui)
			guidelete("Nom")
			ExitLoop
		Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
Wend

$response = MsgBox(4, "Modification Host", "Etes-vous sur de vouloir modifier le fichier Host ?")
If $response = 7 then
	Exit
EndIf

For $i = 1 To $nbnom Step 1
$pc = $oExcel.Activesheet.Cells(1 + $i, 2).Value
$file = FileOpen("\\"&$pc&"\c$\WINDOWS\system32\drivers\etc\hosts", 1)

If $file = -1 Then
	MsgBox(0, "Error", "Impossible d'accèder au fichier host de "&$pc&".")
EndIf

FileWrite($file, @CRLF&$ip&@TAB&$dns)
FileClose($file)

Next																					; Part au debut de la boucle
ProcessClose("Excel.exe")
MsgBox(0,"Terminé","Les modifications sont terminées")

Func _btnSubmit()
    $nMsg = $ok
EndFunc