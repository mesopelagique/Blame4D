//%attributes = {}
var $file; $cmd; $in; $out; $err : Text

$file:="Project/Sources/Classes/Blame.4dm"

$cmd:="git blame -p '"+$file+"'"
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; Folder:C1567(fk database folder:K87:14).platformPath)
LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)

var $blame : Object
$blame:=blame($out)

ASSERT:C1129(Length:C16($blame.currentCommitHash)>0; "no commit hash")
ASSERT:C1129(Not:C34(OB Is empty:C1297($blame.lineData)); "no line data")
ASSERT:C1129(Not:C34(OB Is empty:C1297($blame.commitData)); "no commit data")