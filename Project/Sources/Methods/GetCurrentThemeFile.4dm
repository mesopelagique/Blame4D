//%attributes = {}
#DECLARE()->$file : 4D:C1709.File

var $name : Text

$name:=GetCurrentThemeName
If (Length:C16($name)>0)
	
	$file:=Folder:C1567(fk editor theme folder:K87:23).file($name+".json")
	
Else 
	
	var $folder : 4D:C1709.Folder
	$folder:=Folder:C1567(fk applications folder:K87:20)
	If (Is macOS:C1572)
		$folder:=$folder.folder("Contents")
	End if 
	$file:=$folder.file("Resources/EditorTheme/defaultTheme.json")
	
End if 