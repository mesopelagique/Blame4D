//%attributes = {}
// URL of the "origin" git remote for the current database repository ("" if none).
#DECLARE()->$url : Text

SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; Folder:C1567(fk database folder:K87:14; *).platformPath)
var $cmd; $in; $out; $err : Text
$cmd:=gitPath()+" config --get remote.origin.url"
LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)

$url:=Replace string:C233($out; Char:C90(Carriage return:K15:38); "")
$url:=Replace string:C233($url; Char:C90(Line feed:K15:40); "")
