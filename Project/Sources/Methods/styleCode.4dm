//%attributes = {}
#DECLARE($code : Text; $theme : Object)->$styled : Text

$styled:=$code

// TODO need to encode html code (if contains < etc...)

If (Position:C15("//"; $styled)=1)  // only start comment to start with (then we must use position to changer color only after this po)
	
	$styled:="<span style=\"color:"+$theme["4D"].comments.color+"\">"+$styled+"</span>"
Else 
	// TODO: to regexify
	$styled:=Replace string:C233($styled; "$"; "<span style=\"color:"+$theme["4D"].local_variables.color+"\">$</span>")
	// ex: all with :C
	$styled:=Replace string:C233($styled; "This:C1470"; "<span style=\"color:"+$theme["4D"].commands.color+"\">This</span>")
	
	var $keywords : Collection
	$keywords:=New collection:C1472("Class constructor"; "var "; "Case of"; "End case"; "End if"; "If"; "Else"; "End for each"; "For each"; "End for"; "For"; "#DECLARE"; "Function ")  // TODO make it shared instaciated one time
	var $keyword : Text
	For each ($keyword; $keywords)
		$styled:=Replace string:C233($styled; $keyword; "<span style=\"color:"+$theme["4D"].keywords.color+"\">"+$keyword+"</span>")
	End for each 
End if 
