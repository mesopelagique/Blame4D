//%attributes = {"invisible":true}
// WIP
#DECLARE($method : Text)


var $line : Integer:=5  // XXX need line from macro selection

var $blame:=cs:C1710.Git.me.blameMethod($method)
If ($blame=Null:C1517)
	ALERT:C41("No blame data")
Else
	var $data : Object:=$blame.data($line)
	ALERT:C41(JSON Stringify:C1217($data; *))  // TODO make a better interface, with lisbot
End if 