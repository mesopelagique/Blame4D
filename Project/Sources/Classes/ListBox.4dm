Class extends Object

Function selectRows($rows : Variant; $action : Integer)
	LISTBOX SELECT ROWS:C1715(*; This:C1470.name; $rows; $action)
	
Function getMouseOverCellPosition()->$position : Object
	var $mouseX; $mouseY; $mouseZ : Integer
	GET MOUSE:C468($mouseX; $mouseY; $mouseZ)
	var $col; $row : Integer
	LISTBOX GET CELL POSITION:C971(*; This:C1470.name; $mouseX; $mouseY; $col; $row)
	$position:=New object:C1471("row"; $row; "column"; $col)
	
Function helpTip()->$handled : Boolean
	Case of 
		: (Form event code:C388=On Mouse Enter:K2:33)
			SET DATABASE PARAMETER:C642(Tips delay:K37:80; 1)
			$handled:=True:C214
			
		: (Form event code:C388=On Mouse Move:K2:35)
			
			var $position : Object
			$position:=This:C1470.getMouseOverCellPosition()  // Note: return with tuple will be better than object...
			
			var $helpTip : Text
			// Implemented for collection model (we need interface for generic model)
			If (($position.row#0) & ($position.row<=This:C1470.model.length))
				$helpTip:=This:C1470.getHelpTip(This:C1470.model[$position.row-1]/*row data*/; $position.column)
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