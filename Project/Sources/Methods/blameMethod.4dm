//%attributes = {}
#DECLARE($methodPath : Text; $lines : Text)->$blame : Object

var $file : Text
$file:=fileForMethod($methodPath)

var $lineOption : Text
If (Count parameters:C259>1)
	$lineOption:=" -L "+$lines
Else 
	$lineOption:=""
End if 

// see https://git-scm.com/docs/git-blame
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; Folder:C1567(fk database folder:K87:14; *).platformPath)
var $cmd; $in; $out; $err : Text
$cmd:=gitPath()+" blame"+$lineOption+" -p '"+$file+"'"
LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)

$blame:=blame($out)