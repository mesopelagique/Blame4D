//%attributes = {}
#DECLARE($methodPath : Text; $lines : Text)->$blame : Object

var $file : Text
If (Position:C15("[class]/"; $methodPath)=1)
	$file:="Project/Sources/Classes/"+Substring:C12($methodPath; 9)+".4dm"
Else 
	$file:="Project/Sources/Methods/"+$methodPath+".4dm"
End if 

var $lineOption : Text
If (Count parameters:C259>1)
	$lineOption:=" -L "+$lines
Else 
	$lineOption:=""
End if 

// see https://git-scm.com/docs/git-blame
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; Folder:C1567(fk database folder:K87:14; *).platformPath)
var $cmd; $in; $out; $err : Text
$cmd:="git blame"+$lineOption+" -p '"+$file+"'"
LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)

$blame:=blame($out)