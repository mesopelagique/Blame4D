Class constructor
	This:C1470.author:=""
	This:C1470.authorMail:=""
	This:C1470.authorTime:=""
	This:C1470.authorTz:=""
	This:C1470.committer:=""
	This:C1470.committerMail:=""
	This:C1470.committerTime:=""
	This:C1470.committerTz:=""
	This:C1470.summary:=""
	This:C1470.previousHash:=""
	This:C1470.filename:=""
	
Function authorDate()->$date : Text  // Date if list box could display it correctly
	$date:=cs:C1710.Time.new(Num:C11(This:C1470.authorTime)).toString()
	
Function committerDate()->$date : Text  // Date if list box could display it correctly
	$date:=cs:C1710.Time.new(Num:C11(This:C1470.committerTime)).toString()
	
Function authorGravatar()->$picture : Picture
	$picture:=This:C1470._gravatar("author")
	
Function committerGravatar()->$picture : Picture
	$picture:=This:C1470._gravatar("committer")
	
Function _gravatar($prefix : Text)->$picture : Picture
	If (This:C1470["_"+$prefix+"Gravatar"]=Null:C1517)
		Case of 
			: (Length:C16(String:C10(This:C1470[$prefix+"Mail"]))=0)
				// no mail
			: (Position:C15("not.commit"; String:C10(This:C1470[$prefix+"Mail"]))>0)
				// no mail
			Else 
				var $url : Text
				$url:=gravatarURL(This:C1470[$prefix+"Mail"])
				var $code : Integer
				var $pictureBlob : Blob
				$code:=HTTP Get:C1157($url+"?s=20"; $pictureBlob)
				
				BLOB TO PICTURE:C682($pictureBlob; $picture)
				This:C1470["_"+$prefix+"Gravatar"]:=$picture
		End case 
	End if 
	$picture:=This:C1470["_"+$prefix+"Gravatar"]
	