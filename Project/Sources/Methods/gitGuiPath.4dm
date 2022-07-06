//%attributes = {}
#DECLARE()->$path : Text

If (Is Windows:C1573)
	$path:="git-gui.exe"
Else 
	If (File:C1566("/usr/local/bin/git-gui").exists)
		$path:="/usr/local/bin/git-gui"  // prefer more recent one installed by user instead of OS one
	Else 
		$path:="git-gui"
	End if 
End if 