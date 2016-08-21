#include <File.au3>

;Example: Remplace la ligne 3 du fichier c:\test.txt
FileWrite("Clean\hosts.txt", 3, "Texte de remplacement de la ligne 3", 1)
;Example: Ecrit à la ligne 3 (sans remplacer) du fichier c:\test.txt
_FileWriteToLine("Clean\hosts.txt", 3, "Texte ajouté", 0)