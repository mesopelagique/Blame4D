//%attributes = {"invisible":true}
// WIP
#DECLARE($method : Text)


var $line:="5"  // XXX need line from macro selection
var $lines:=String:C10($line)+",+1"

var $blame:=blameMethod($method)
If ($blame=Null:C1517)
	ALERT:C41("No blame data")
Else 
	var $data : Object:=$blame.data($line)
	ALERT:C41(JSON Stringify:C1217($data; *))  // TODO make a better interface, with lisbot
End if 