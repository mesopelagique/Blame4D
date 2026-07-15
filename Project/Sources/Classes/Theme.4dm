// Access to the current 4D editor theme: color scheme, theme files and
// resolved theme objects (colors + font). Singleton: cs.Theme.me
// Replaces the former GetCurrentTheme / GetCurrentThemeFile / GetCurrentThemeName methods.

singleton Class constructor()
	
	// Color scheme in effect: "dark" or "light".
Function get scheme()->$scheme : Text
	var $mOnError : Text
	$mOnError:=Method called on error:C704
	ON ERR CALL:C155("ignoreError")
	$scheme:=Get Application color scheme:C1763
	ON ERR CALL:C155($mOnError)
	If ($scheme#"dark")
		$scheme:="light"
	End if 
	
	// Resources folder of the running 4D application.
	// Application file is the .app package (folder) on macOS, the .exe (file) on Windows.
Function get applicationResources()->$folder : 4D:C1709.Folder
	If (Is macOS:C1572)
		$folder:=Folder:C1567(Application file:C491; fk platform path:K87:2).folder("Contents/Resources")
	Else 
		$folder:=File:C1566(Application file:C491; fk platform path:K87:2).parent.folder("Resources")
	End if 
	
	// Folder holding the user's editor themes.
Function get themesFolder()->$folder : 4D:C1709.Folder
	$folder:=Folder:C1567(fk editor theme folder:K87:23)
	
	// Theme JSON file for a name: user themes folder first, then application built-in themes.
Function fileForName($name : Text)->$file : 4D:C1709.File
	$file:=This:C1470.themesFolder.file($name+".json")
	If (Not:C34($file.exists))
		$file:=This:C1470.applicationResources.folder("EditorTheme").file($name+".json")
	End if 
	
	// Name of the current editor theme (read from 4D Preferences), "" if none is set.
Function get currentName()->$name : Text
	var $pref : 4D:C1709.File
	$pref:=Folder:C1567(fk user preferences folder:K87:10).file("4D Preferences v"+Substring:C12(Application version:C493; 1; 2)+".4DPreferences")
	If (Not:C34($pref.exists))
		return 
	End if 
	
	var $mOnError : Text
	$mOnError:=Method called on error:C704
	var $domRoot; $dom : Text
	$domRoot:=DOM Parse XML source:C719($pref.platformPath)
	
	// color scheme preference: "light", "dark" or "inherited"
	var $colorScheme : Text
	$colorScheme:="inherited"
	$dom:=DOM Find XML element:C864($domRoot; "//com.4d/general")
	ON ERR CALL:C155("ignoreError")
	DOM GET XML ATTRIBUTE BY NAME:C728($dom; "color_scheme"; $colorScheme)
	ON ERR CALL:C155($mOnError)
	
	// <theme dark="absent-light" light="defaultDarkTheme" theme_name="absent-contrast"/>
	$dom:=DOM Find XML element:C864($domRoot; "//theme")
	If ($dom#"00000000000000000000000000000000")
		var $attr : Text
		Case of 
			: ($colorScheme="light")
				$attr:="light"
			: ($colorScheme="dark")
				$attr:="dark"
			Else   // inherited: follow the application / system scheme
				$attr:=This:C1470.scheme
		End case 
		ON ERR CALL:C155("ignoreError")
		DOM GET XML ATTRIBUTE BY NAME:C728($dom; $attr; $name)
		If (Length:C16($name)=0)
			DOM GET XML ATTRIBUTE BY NAME:C728($dom; "theme_name"; $name)  // legacy fallback
		End if 
		ON ERR CALL:C155($mOnError)
	End if 
	DOM CLOSE XML:C722($domRoot)
	
	// JSON file of the current theme, falling back to the built-in default for the scheme.
Function get currentFile()->$file : 4D:C1709.File
	var $name : Text
	$name:=This:C1470.currentName
	If (Length:C16($name)>0)
		$file:=This:C1470.fileForName($name)
	End if 
	If (($file=Null:C1517) || (Not:C34($file.exists)))
		$file:=This:C1470.applicationResources.folder("EditorTheme").file((This:C1470.scheme="dark") ? "defaultDarkTheme.json" : "defaultTheme.json")
	End if 
	
	// The current theme object (inheritance resolved), or Null.
Function get current()->$theme : Object
	$theme:=This:C1470._resolve(This:C1470.currentFile)
	
	// A named theme object (inheritance resolved), or Null if it does not exist.
Function forName($name : Text)->$theme : Object
	$theme:=This:C1470._resolve(This:C1470.fileForName($name))
	
	// (internal) parse a theme file and merge keys inherited via __inheritedFrom__.
Function _resolve($themeFile : 4D:C1709.File)->$theme : Object
	If (($themeFile=Null:C1517) || (Not:C34($themeFile.exists)))
		return   // $theme stays Null
	End if 
	$theme:=JSON Parse:C1218($themeFile.getText())
	
	// custom themes may be partial and inherit from a base theme
	var $baseName : Text
	$baseName:=String:C10($theme.__inheritedFrom__)
	If (Length:C16($baseName)=0)
		return 
	End if 
	var $baseFile : 4D:C1709.File
	$baseFile:=This:C1470.fileForName($baseName)
	If (Not:C34($baseFile.exists))
		return 
	End if 
	
	var $base : Object
	$base:=JSON Parse:C1218($baseFile.getText())
	var $section : Text
	For each ($section; ["4D"; "JSON"; "SQL"; "otherStyles"])
		Case of 
			: ($base[$section]=Null:C1517)
				// nothing to inherit
			: ($theme[$section]=Null:C1517)
				$theme[$section]:=$base[$section]
			Else 
				var $entry : Object
				For each ($entry; OB Entries:C1720($base[$section]))
					If ($theme[$section][$entry.key]=Null:C1517)
						$theme[$section][$entry.key]:=$entry.value
					End if 
				End for each 
		End case 
	End for each 
	