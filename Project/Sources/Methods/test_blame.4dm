//%attributes = {}
var $file : Text
$file:="Project/Sources/Classes/Blame.4dm"

// see https://git-scm.com/docs/git-blame
$cmd:="git blame -L 2,50 -p '"+$file+"'"
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; Folder:C1567(fk database folder:K87:14).platformPath)
var $cmd; $in; $out; $err : Text
LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)

var $blame : Object
$blame:=blame($out)

ASSERT:C1129(Not:C34(OB Is empty:C1297($blame.lineData)); "no line data")
ASSERT:C1129(Not:C34(OB Is empty:C1297($blame.commitData)); "no commit data")

var $data : Object
$data:=$blame.data(5)
ASSERT:C1129(Not:C34(OB Is empty:C1297($data)); "no line data for line 5")
ASSERT:C1129(Not:C34(OB Is empty:C1297($data.commit)); "no commit data for line 5")

$data:=$blame.data(1)
ASSERT:C1129($data=Null:C1517; "must have no commit data for line 1")  // see git blame option -L
