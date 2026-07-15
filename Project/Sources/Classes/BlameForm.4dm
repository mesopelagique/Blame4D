
property remoteURL : Text  // git "origin" remote, cached on load

Class constructor
	Form:C1466.listBox:=cs:C1710.ListBox.new(OBJECT Get name:C1087(Object current:K67:2))

Function handle()

	Case of
		: (Form event code:C388=On Load:K2:1)
			This:C1470.setFontFromTheme()
			This:C1470.initTestData()

			Form:C1466.listBox.model:=Form:C1466.blame
			Form:C1466.listBox.getHelpTip:=This:C1470.getHelpTip
			This:C1470.remoteURL:=String:C10(Try(gitRemoteURL))

		: (Form event code:C388=On Clicked:K2:4)
			If (Contextual click)
				This:C1470.contextualMenu()
			End if

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
	var $highlighter : cs:C1710.Highlighter
	var $onErr : Text
	$onErr:=Method called on error:C704
	ON ERR CALL:C155("ignoreError")
	$highlighter:=cs:C1710.Highlighter.me
	ON ERR CALL:C155($onErr)
	If ($highlighter#Null:C1517)
		If ((Length:C16($highlighter.fontName)>0) && ($highlighter.fontName#"default_font"))
			Form:C1466.listBox.setFont($highlighter.fontName)
		End if
		If ($highlighter.fontSize>0)
			Form:C1466.listBox.setFontSize($highlighter.fontSize)
		End if
		// theme colors for the columns without a hashcolor row background
		var $column : Text
		For each ($column; ["Column1"; "Column2"; "Column5"])
			cs:C1710.Object.new($column).setColors($highlighter.plainColor; $highlighter.backColor)
		End for each
	End if
	
Function getHelpTip($rowData : Object; $col : Integer)->$tip : Text
	Case of 
		: ($col=3)
			$tip:=String:C10($rowData.value.commit.author)+" "+String:C10($rowData.value.commit.authorMail)
		: ($col=4)
			$tip:=String:C10($rowData.value.hash)+"\n"+String:C10($rowData.value.commit.summary)
		Else 
			$tip:=""
	End case 
	
Function contextualMenu()
	var $pos : Object
	$pos:=Form:C1466.listBox.getMouseOverCellPosition()
	If (($pos.row=0) || ($pos.row>Form:C1466.blame.length))
		return  // clicked outside the rows
	End if

	var $row : Object
	$row:=Form:C1466.blame[$pos.row-1].value

	var $code; $author; $hash : Text
	$code:=String:C10($row.code)
	$hash:=String:C10($row.hash)
	If ($row.commit#Null:C1517)
		$author:=String:C10($row.commit.author)
		If (Length:C16(String:C10($row.commit.authorMail))>0)
			$author:=$author+" "+String:C10($row.commit.authorMail)
		End if
	End if

	// menu: three copies, plus "open commit" when the remote is GitHub/GitLab
	var $menu : Text
	$menu:="Copy code;Copy author;Copy SHA-1"
	var $url : Text
	$url:=commitURL(This:C1470.remoteURL; $hash)
	var $openIndex : Integer
	If (Length:C16($url)>0)
		$menu:=$menu+";(-;Open commit on "+((Position:C15("github"; This:C1470.remoteURL)>0) ? "GitHub" : "GitLab")
		$openIndex:=5  // separators count in Pop up menu numbering
	End if

	// default item follows the clicked column
	var $default : Integer
	Case of
		: ($pos.column=3)  // author (gravatar) column
			$default:=2
		: ($pos.column>=4)  // summary / date columns → commit id
			$default:=3
		Else   // line number / code columns
			$default:=1
	End case

	var $choice : Integer
	$choice:=Pop up menu($menu; $default)
	Case of
		: ($choice=1)
			SET TEXT TO PASTEBOARD($code)
		: ($choice=2)
			SET TEXT TO PASTEBOARD($author)
		: ($choice=3)
			SET TEXT TO PASTEBOARD($hash)
		: (($openIndex>0) && ($choice=$openIndex))
			OPEN URL($url)
	End case

Function initTestData
	If (Form:C1466.blame=Null:C1517)
		Form:C1466.blame:=blameMethod("[class]/Blame").toCollection()  // test data
	End if
	