//%attributes = {}
#DECLARE()->$name : Text

// read in 4D Preferences v18.4DPreferences
var $pref : 4D:C1709.File
$pref:=Folder:C1567(fk user preferences folder:K87:10).file("4D Preferences v"+Substring:C12(Application version:C493; 1; 2)+".4DPreferences")

If ($pref.exists)
	var $domRoot; $dom : Text
	
	// the theme name <theme theme_name="synthwave-color-theme"/>
	$domRoot:=DOM Parse XML source:C719($pref.platformPath)
	var $color_scheme : Text
	$color_scheme:="inherited"
	
	$dom:=DOM Find XML element:C864($domRoot; "//com.4d/general")
	var $mOnError : Text
	$mOnError:=Method called on error:C704
	ON ERR CALL:C155("void")
	DOM GET XML ATTRIBUTE BY NAME:C728($dom; "color_scheme"; $color_scheme)
	ON ERR CALL:C155($mOnError)
	
	
	$dom:=DOM Find XML element:C864($domRoot; "//theme")
	
	If ($dom#"00000000000000000000000000000000")
		$mOnError:=Method called on error:C704
		
		
		var $currentAttr : Text
		Case of 
			: ($color_scheme="light")
				$currentAttr:="light"
			: ($color_scheme="dark")
				$currentAttr:="dark"
			Else   // inherited
				$currentAttr:="theme_name"
		End case 
		
		
		ON ERR CALL:C155("void")
		// <theme dark="absent-light" light="defaultDarkTheme" theme_name="absent-contrast"/>
		DOM GET XML ATTRIBUTE BY NAME:C728($dom; $currentAttr; $name)
		ON ERR CALL:C155($mOnError)
	End if 
	
	DOM CLOSE XML:C722($domRoot)
End if 