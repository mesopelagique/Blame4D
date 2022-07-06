//%attributes = {"invisible":true,"shared":true}
#DECLARE($methodPath : Text)

var $file : Text
$file:=fileForMethod($methodPath)


// see https://git-scm.com/docs/git-gui
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; Folder:C1567(fk database folder:K87:14; *).platformPath)
var $cmd; $in; $out; $err : Text
$cmd:=gitGuiPath+" blame '"+$file+"'"
LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)
