
Class constructor
	Form:C1466.listBox:=cs:C1710.ListBox.new(OBJECT Get name:C1087(Object current:K67:2))
	
Function handle()
	
	Case of 
		: (Form event code:C388=On Load:K2:1)
			This:C1470.setFontFromTheme()
			This:C1470.initTestData()
			
			Form:C1466.listBox.model:=Form:C1466.blame
			Form:C1466.listBox.getHelpTip:=This:C1470.getHelpTip
			
		: (Form event code:C388=On Selection Change:K2:29)
			
			If (Form:C1466.listBox.selected#Null:C1517)
				If (Form:C1466.listBox.selected.length>0)
					var $lines : Collection
					$lines:=Form:C1466.blame.query("value.hash=:1"; Form:C1466.listBox.selected[0].value.hash)
					
					Form:C1466.listBox.selectRows($lines; lk replace selection:K53:1)
				End if 
			End if 
		: (Form:C1466.listBox.helpTip())
			// handled
		Else 
			
	End case 
	
Function setFontFromTheme()
	var $theme : Object
	$theme:=GetCurrentTheme
	If ($theme#Null:C1517)
		Form:C1466.listBox.setFont($theme.fontName)
		Form:C1466.listBox.setFontSize(Num:C11($theme.fontSize))
	End if 
	
Function getHelpTip($rowData : Object; $col : Integer)->$tip : Text
	Case of 
		: ($col=3)
			$tip:=String:C10($rowData.value.commit.author)+" "+String:C10($rowData.value.commit.authorMail)
		: ($col=4)
			$tip:=String:C10($rowData.value.hash)
		Else 
			$tip:=""
	End case 
	
Function initTestData
	If (Form:C1466.blame=Null:C1517)
		Form:C1466.blame:=blameMethod("[class]/Blame").toCollection()  // test data
	End if 
	