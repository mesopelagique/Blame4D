

Case of 
	: (Form event code:C388=On Load:K2:1)
		
		var $themeFile : 4D:C1709.File
		$themeFile:=GetCurrentThemeFile
		If ($themeFile.exists)
			var $theme : Object
			$theme:=JSON Parse:C1218($themeFile.getText())
			OBJECT SET FONT:C164(*; "List Box"; $theme.fontName)
			OBJECT SET FONT SIZE:C165(*; "List Box"; Num:C11($theme.fontSize))
			
		End if 
		
		
	Else 
		
End case 