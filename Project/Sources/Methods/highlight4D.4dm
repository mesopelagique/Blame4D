//%attributes = {}
// Colorize basic 4D keywords, strings and comments as multi-style text (<span> tags).
// Meant as a list box column data source when the column has "styledText" enabled.
#DECLARE($code : Text)->$styled : Text

// --- palette (tweak to taste) ---
var $keywordColor : Text:="#0033CC"
var $stringColor : Text:="#A31515"
var $commentColor : Text:="#008000"

// Basic 4D keywords, lowercased (matched case-insensitively, whole word only)
var $keywords : Collection
$keywords:=["if"; "else"; "end"; "for"; "each"; "while"; "repeat"; "until"; "case"; "of"; "return"; "var"; "function"; "class"; "extends"; "property"; "this"; "super"; "true"; "false"; "null"]

// Escape HTML-significant characters once, then scan the escaped text verbatim.
var $esc : Text:=$code
$esc:=Replace string:C233($esc; "&"; "&amp;")
$esc:=Replace string:C233($esc; "<"; "&lt;")
$esc:=Replace string:C233($esc; ">"; "&gt;")

var $wordChars : Text:="_abcdefghijklmnopqrstuvwxyz0123456789"  // case-insensitive match
var $len : Integer:=Length:C16($esc)
var $i; $j; $k : Integer
var $c; $word : Text
var $scanning : Boolean

// Note: 4D's & operator does not short-circuit, so bounds are checked before any [[index]].
var $isComment : Boolean
$styled:=""
$i:=1
While ($i<=$len)
	$c:=$esc[[$i]]
	$isComment:=False:C215
	If (($c="/") & ($i<$len))
		$isComment:=($esc[[$i+1]]="/")
	End if
	Case of
		: ($isComment)  // line comment → end of line
			$styled:=$styled+"<span style=\"color:"+$commentColor+"\">"+Substring:C12($esc; $i)+"</span>"
			$i:=$len+1

		: ($c="\"")  // string literal
			$j:=$i+1
			$scanning:=True:C214
			While ($scanning & ($j<=$len))
				Case of
					: ($esc[[$j]]="\"")  // closing quote
						$scanning:=False:C215
					: ($esc[[$j]]="\\")  // skip escaped char
						$j:=$j+2
					Else
						$j:=$j+1
				End case
			End while
			$styled:=$styled+"<span style=\"color:"+$stringColor+"\">"+Substring:C12($esc; $i; $j-$i+1)+"</span>"
			$i:=$j+1

		: (Position:C15($c; $wordChars)>0)  // identifier or keyword
			$k:=$i+1
			$scanning:=True:C214
			While ($scanning & ($k<=$len))
				If (Position:C15($esc[[$k]]; $wordChars)>0)
					$k:=$k+1
				Else
					$scanning:=False:C215
				End if
			End while
			$word:=Substring:C12($esc; $i; $k-$i)
			If ($keywords.indexOf(Lowercase:C14($word))#-1)
				$styled:=$styled+"<span style=\"color:"+$keywordColor+"\">"+$word+"</span>"
			Else
				$styled:=$styled+$word
			End if
			$i:=$k

		Else
			$styled:=$styled+$c
			$i:=$i+1
	End case
End while
