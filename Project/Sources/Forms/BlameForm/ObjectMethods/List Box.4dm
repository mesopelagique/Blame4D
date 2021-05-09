

Case of 
	: (Form event code:C388=On Load:K2:1)
		var $themeFile : 4D:C1709.File
		$themeFile:=GetCurrentThemeFile
		If ($themeFile.exists)
			var $theme : Object
			$theme:=JSON Parse:C1218($themeFile.getText())
			OBJECT SET FONT:C164(*; OBJECT Get name:C1087(Object current:K67:2); $theme.fontName)
			OBJECT SET FONT SIZE:C165(*; OBJECT Get name:C1087(Object current:K67:2); Num:C11($theme.fontSize))
		End if 
		
		If (Form:C1466.blame=Null:C1517)
			Form:C1466.blame:=blameMethod("[class]/Blame").toCollection()  // test data
		End if 
		
	: (Form event code:C388=On Mouse Enter:K2:33)
		SET DATABASE PARAMETER:C642(Tips delay:K37:80; 1)
		
	: (Form event code:C388=On Mouse Move:K2:35)
		
		GET MOUSE:C468($mouseX; $mouseY; $mouseZ)
		LISTBOX GET CELL POSITION:C971(*; OBJECT Get name:C1087(Object current:K67:2); $mouseX; $mouseY; $col; $row)
		
		$tips:=""
		If (($row#0) & ($row<Form:C1466.blame.length))
			Case of 
				: ($col=3)
					$tips:=String:C10(Form:C1466.blame[$row].value.commit.author)+" "+String:C10(Form:C1466.blame[$row].value.commit.authorMail)
				: ($col=4)
					$tips:=String:C10(Form:C1466.blame[$row].value.hash)
			End case 
			
		End if 
		OBJECT SET HELP TIP:C1181(*; OBJECT Get name:C1087(Object current:K67:2); $tips)
		
	: (Form event code:C388=On Mouse Leave:K2:34)
		SET DATABASE PARAMETER:C642(Tips delay:K37:80; 3)
End case 
