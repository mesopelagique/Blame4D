Class constructor($blame : Text)
	This:C1470.commitData:=New object:C1471()
	This:C1470.lineData:=New object:C1471()
	This:C1470._settingCommitData:=False:C215
	This:C1470.currentCommitHash:=""
	This:C1470.currentLineNumber:=1
	
	This:C1470._parseBlame($blame)
	
Function data($line : Integer)->$data : Object
	If (This:C1470.lineData[String:C10($line)]=Null:C1517)
		// return null
	Else 
		$data:=OB Copy:C1225(This:C1470.lineData[String:C10($line)])
		$data.commit:=This:C1470.commitData[$data.hash]
	End if 
	
Function _parseBlame($blame : Text)->$parsed : Boolean
	$parsed:=False:C215
	// Split up the original document into an array of lines
	var $lines : Collection
	$lines:=Split string:C1554($blame; "\n")
	If ($lines.length>0)
		
		// Go through each line
		var $i : Integer
		For ($i; 0; $lines.length-1; 1)
			Case of 
				: (Length:C16($lines[$i])=0)
					// ignore
				: ($lines[$i][[1]]="\t")
					
					// The first tab is an addition made by git, so get rid of it
					This:C1470.lineData[This:C1470.currentLineNumber].code:=Substring:C12($lines[$i]; 2)
					This:C1470._settingCommitData:=False:C215
					This:C1470.currentCommitHash:=""
				Else 
					
					var $arrLine : Collection
					$arrLine:=Split string:C1554($lines[$i]; " ")
					// If we are in the process of collecting data about a commit summary
					If (This:C1470._settingCommitData)
						This:C1470._parseCommitLine($arrLine); 
					Else 
						// 40 == the length of an Sha1
						// This is really only an added check, we should be guaranteed
						// that an Sha1 is expected here
						If (Length:C16($arrLine[0])=40)
							This:C1470.currentCommitHash:=$arrLine[0]
							This:C1470.currentLineNumber:=$arrLine[2]
							
							// Setup the new lineData hash
							This:C1470.lineData[This:C1470.currentLineNumber]:=New object:C1471(\
								"code"; ""; \
								"hash"; This:C1470.currentCommitHash; \
								"originalLine"; Num:C11($arrLine[1]); \
								"finalLine"; Num:C11(This:C1470.currentLineNumber))
							If ($arrLine.length>3)
								This:C1470.lineData[This:C1470.currentLineNumber].numLines:=Num:C11($arrLine[3])-1
							End if 
							
							// Since the commit data (author, committer, summary, etc) only
							// appear once in a porcelain output for every commit, we set
							// it up once here and then expect that the next 8-11 lines of
							// the file are dedicated to that data
							If (This:C1470.commitData[This:C1470.currentCommitHash]=Null:C1517)
								This:C1470._settingCommitData:=True:C214
								This:C1470.commitData[This:C1470.currentCommitHash]:=cs:C1710.CommitData.new()
							End if 
							This:C1470.lineData[This:C1470.currentLineNumber].commit:=This:C1470.commitData[This:C1470.currentCommitHash]
						End if 
					End if 
			End case 
		End for 
		
		$parsed:=True:C214
	End if 
	
/**
 * Parses and sets data from a line following a commit header
 *
 * @param {Collection} lineArr The current line split by a space
*/
Function _parseCommitLine($lineArr : Collection)
	var $currentCommitData : Object
	$currentCommitData:=This:C1470.commitData[This:C1470.currentCommitHash]
	Case of 
		: ($lineArr[0]="author")
			$currentCommitData.author:=$lineArr.slice(1).join(" ")
		: ($lineArr[0]="author-mail")
			$currentCommitData.authorMail:=$lineArr[1]
		: ($lineArr[0]="author-time")
			$currentCommitData.authorTime:=$lineArr[1]
		: ($lineArr[0]="author-tz")
			$currentCommitData.authorTz:=$lineArr[1]
		: ($lineArr[0]="committer")
			$currentCommitData.committer:=$lineArr.slice(1).join(" ")
		: ($lineArr[0]="committer-mail")
			$currentCommitData.committerMail:=$lineArr[1]
		: ($lineArr[0]="committer-time")
			$currentCommitData.committerTime:=$lineArr[1]
		: ($lineArr[0]="committer-tz")
			$currentCommitData.committerTz:=$lineArr[1]
		: ($lineArr[0]="summary")
			$currentCommitData.summary:=$lineArr.slice(1).join(" ")
		: ($lineArr[0]="filename")
			$currentCommitData.filename:=$lineArr[1]
		: ($lineArr[0]="previous")
			$currentCommitData.previous:=$lineArr.slice(1).join(" ")
		Else 
			// break
	End case 
	
Function toCollection()->$collection : Collection
	$collection:=OB Entries:C1720(This:C1470.lineData)
	
Function _toText()->$text : Text
	$text:=""
	var $collection : Collection
	$collection:=OB Entries:C1720(This:C1470.lineData)
	var $lineEntry : Object
	// TODO sort by key if necessary
	For each ($lineEntry; $collection)
		If ($lineEntry.value.numLines=Null:C1517)
			$text:=$text+"\n"  // same commit
		Else 
			$text:=$text+"\n"+String:C10($lineEntry.value.commit.summary)
		End if 
	End for each 
	
	
	