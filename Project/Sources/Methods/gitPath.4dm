//%attributes = {}
#DECLARE()->$path : Text

If (Is Windows:C1573)
	$path:="git.exe"
Else 
	If (File:C1566("/usr/local/bin/git").exists)
		$path:="/usr/local/bin/git"  // prefer more recent one installed by user instead of OS one
	Else 
		$path:="git"
	End if 
End if 