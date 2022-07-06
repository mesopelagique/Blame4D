//%attributes = {"invisible":true,"shared":true}
#DECLARE($methodPath : Text; $lines : Text)->$blame : Object

var $file : Text
$file:=fileForMethod($methodPath)

var $options : Text
If (Count parameters:C259>1)
	$options:=" -L "+$lines
Else 
	$options:=""
End if 

If (Folder:C1567(fk database folder:K87:14; *).file(".git-ignore-revs-file").exists)
	$options:=$options+" --ignore-revs-file '"+Folder:C1567(fk database folder:K87:14; *).file(".git-ignore-revs-file").path+"'"
End if 


// see https://git-scm.com/docs/git-blame
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; Folder:C1567(fk database folder:K87:14; *).platformPath)
var $cmd; $in; $out; $err : Text
$cmd:=gitGuiPath()+" blame"+$options+" -p '"+$file+"'"
LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)

$blame:=blame($out)