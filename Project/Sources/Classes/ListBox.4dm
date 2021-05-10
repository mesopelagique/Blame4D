Class extends Object


Function getMouseOverCellCoordinates()->$coordinates : Object
	
	var $mouseX; $mouseY; $mouseZ : Integer
	GET MOUSE:C468($mouseX; $mouseY; $mouseZ)
	var $col; $row : Integer
	LISTBOX GET CELL POSITION:C971(*; This:C1470.name; $mouseX; $mouseY; $col; $row)
	$coordinates:=New object:C1471("row"; $row; "column"; $col)
	
Function helpTip()->$handled : Boolean
	Case of 
		: (Form event code:C388=On Mouse Enter:K2:33)
			SET DATABASE PARAMETER:C642(Tips delay:K37:80; 1)
			$handled:=True:C214
			
		: (Form event code:C388=On Mouse Move:K2:35)
			
			var $coord : Object
			$coord:=This:C1470.getMouseOverCellCoordinates()  // Note: return with tuple will be better than object...
			
			var $helpTip : Text
			// Implemented for collection model (we need interface for generic model)
			If (($coord.row#0) & ($coord.row<=This:C1470.model.length))
				$helpTip:=This:C1470.getHelpTip(This:C1470.model[$coord.row-1]/*row data*/; $coord.column)
			Else 
				$helpTip:=""
			End if 
			This:C1470.setHelpTip($helpTip)
			$handled:=True:C214
			
		: (Form event code:C388=On Mouse Leave:K2:34)
			SET DATABASE PARAMETER:C642(Tips delay:K37:80; 3)
			$handled:=True:C214
			
		Else 
			$handled:=False:C215
			
	End case 