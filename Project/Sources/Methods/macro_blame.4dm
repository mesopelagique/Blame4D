//%attributes = {}
// WIP
C_TEXT:C284($1)

var $line; $lines : Text
$line:="5"  // XXX need line from macro selection
$lines:=String:C10($line)+",+1"

var $blame : Object
$blame:=blameMethod($1)
If ($blame=Null:C1517)
	ALERT:C41("No blame data")
Else 
	var $data : Object
	$data:=$blame.data($line)
	ALERT:C41(JSON Stringify:C1217($data; *))  // TODO make a better interface, with lisbot
End if 