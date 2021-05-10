Class constructor($epoch : Real)
	If (Count parameters:C259>0)
		var $seconds : Integer
		$seconds:=Mod:C98($epoch; 86400)
		
		var $days : Integer
		$days:=Trunc:C95($epoch/86400; 0)
		var $date : Date
		$date:=!1970-01-01!+$days
		
		var $timeStamp : Text
		$timeStamp:=String:C10($date; ISO date:K1:8; Time:C179(Time string:C180($seconds)))+"Z"
		This:C1470.date:=Date:C102($timeStamp)
		This:C1470.time:=Time:C179($timeStamp)
	Else 
		This:C1470.time:=Current time:C178()
		This:C1470.date:=Current date:C33()
	End if 
	
Function toString()->$timeStamp : Text
	$timeStamp:=String:C10(This:C1470.date; ISO date:K1:8; Time:C179(This:C1470.time))  // time is converted to real, need to reconvert it