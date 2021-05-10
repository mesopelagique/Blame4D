Class constructor($objectName : Text)
	This:C1470.name:=$objectName
	
Function setFont($fontName : Text)
	OBJECT SET FONT:C164(*; This:C1470.name; $fontName)
	
Function setFontSize($fontSize : Integer)
	OBJECT SET FONT SIZE:C165(*; This:C1470.name; $fontSize)
	
Function setHelpTip($tip : Text)
	OBJECT SET HELP TIP:C1181(*; This:C1470.name; $tip)