//%attributes = {}
// Background color for a blame row: the theme's (soft) selection color when the row
// belongs to the selected commit, otherwise $default. Used as a list box background
// color expression, together with the "Hide selection highlight" list box option.
#DECLARE($rowData : Object; $default : Text)->$color : Text

$color:=$default

If (Form:C1466.listBox=Null:C1517)
	return
End if
var $selected : Collection
$selected:=Form:C1466.listBox.selected
If (($selected#Null:C1517) && ($selected.length>0))
	If ($selected[0].value.hash=$rowData.value.hash)  // selection is always one whole commit
		$color:=cs:C1710.Highlighter.me.selectionColor
	End if
End if
