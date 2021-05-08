//%attributes = {}
var $blame : Object
$blame:=blameMethod(Current method path:C1201)

ASSERT:C1129(Not:C34(OB Is empty:C1297($blame.lineData)); "no line data")
ASSERT:C1129(Not:C34(OB Is empty:C1297($blame.commitData)); "no commit data")

var $data : Object
$data:=$blame.data(8)  // 8 is line 7 because of method header
ASSERT:C1129(Not:C34(OB Is empty:C1297($data)); "no line data for line 8")
ASSERT:C1129(Not:C34(OB Is empty:C1297($data.commit)); "no commit data for line 8")
