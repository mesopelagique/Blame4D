//%attributes = {"invisible":true,"shared":true}
#DECLARE($methodPath : Text)
var $data : Collection
$data:=blameMethod($methodPath).toCollection()

DIALOG:C40("BlameForm"; New object:C1471("blame"; $data))