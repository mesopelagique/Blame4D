property name : Text

Class constructor($objectName : Text)
	This:C1470.name:=$objectName
	
Function setFont($fontName : Text)
	OBJECT SET FONT:C164(*; This:C1470.name; $fontName)
	
Function setFontSize($fontSize : Integer)
	OBJECT SET FONT SIZE:C165(*; This:C1470.name; $fontSize)
	
Function setHelpTip($tip : Text)
	OBJECT SET HELP TIP:C1181(*; This:C1470.name; $tip)

Function setColors($frontColor : Text; $backColor : Text)
	OBJECT SET RGB COLORS(*; This:C1470.name; This:C1470._colorToInt($frontColor); This:C1470._colorToInt($backColor))

Function _colorToInt($hexColor : Text)->$color : Integer
	// "#RRGGBB" → 0x00RRGGBB
	var $i : Integer
	For ($i; 2; Length:C16($hexColor); 1)
		$color:=($color << 4)+Position:C15($hexColor[[$i]]; "123456789ABCDEF")  // "0" not found → 0
	End for