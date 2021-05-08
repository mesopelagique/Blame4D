//%attributes = {}
ARRAY TEXT:C222($arrPaths; 0)
METHOD GET PATHS:C1163("test"; Path project method:K72:1; $arrPaths)

var $i : Integer
For ($i; 1; Size of array:C274($arrPaths); 1)
	If (Position:C15("test_"; $arrPaths{$i})=1)
		EXECUTE METHOD:C1007($arrPaths{$i})
	End if 
End for 
