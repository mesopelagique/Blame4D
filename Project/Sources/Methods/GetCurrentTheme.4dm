//%attributes = {}
#DECLARE()->$theme : Object

var $themeFile : 4D:C1709.File
$themeFile:=GetCurrentThemeFile
If ($themeFile.exists)
	$theme:=JSON Parse:C1218($themeFile.getText())
Else 
	$theme:=Null:C1517
End if 

