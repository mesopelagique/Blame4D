//%attributes = {"invisible":true,"shared":true}
#DECLARE($methodPath : Text)

var $file : Text
$file:=fileForMethod($methodPath)


// see https://git-scm.com/docs/git-gui
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; Folder:C1567(fk database folder:K87:14; *).platformPath)
var $cmd; $in; $out; $err : Text
$cmd:=gitPath()+" gui blame '"+$file+"'"
LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)

If (Position:C15("git: 'gui'"; $err)=1)
	ALERT:C41("Please update git or install git gui")
	OPEN URL:C673("https://git-scm.com/docs/git-gui")
End if 