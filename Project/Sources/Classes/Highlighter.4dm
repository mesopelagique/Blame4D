// Theme-aware 4D code highlighter producing multi-style text (<span> tags).
// Colors come from the current 4D editor theme (see cs.Theme);
// the default light theme values are used as fallback.
// Singleton: the theme is loaded once per process (cs.Highlighter.me).

property spans : Object  // token name → opening <span> tag
property keywords : Collection
property types : Collection
property plainColor : Text
property backColor : Text
property selectionColor : Text
property fontName : Text
property fontSize : Integer

singleton Class constructor()
	This.load(Try(cs.Theme.me.current))

// Build the palette from a theme object; may be called again to switch theme at runtime
Function load($theme : Object)
	If ($theme=Null)
		$theme:={}
	End if
	var $t4d : Object
	$t4d:=$theme["4D"]
	If ($t4d=Null)
		$t4d:={}
	End if
	var $json : Object
	$json:=$theme.JSON
	If ($json=Null)
		$json:={}
	End if
	var $other : Object
	$other:=$theme.otherStyles
	If ($other=Null)
		$other:={}
	End if

	This.plainColor:=This._color($t4d.plain_text; "#000000")
	This.backColor:=This._color($other.back_color; "#FFFFFF")
	This.selectionColor:=This._color($other.selection_back_color; "#A5D4EA")  // softer than the system accent
	This.fontName:=String($theme.fontName)
	This.fontSize:=Num($theme.fontSize)

	This.spans:={}
	This.spans.keyword:=This._tag($t4d.keywords; "#034D00"; True)
	This.spans.command:=This._tag($t4d.commands; "#068C00"; True)
	This.spans.constant:=This._tag($t4d.constants; "#4D004D"; False)
	This.spans.comment:=This._tag($t4d.comments; "#535353"; False)
	This.spans.string:=This._tag($json.strings; "#A0806B"; False)  // no string token in the "4D" section
	This.spans.localVariable:=This._tag($t4d.local_variables; "#0031FF"; False)
	This.spans.interprocessVariable:=This._tag($t4d.interprocess_variables; "#FF0088"; False)
	This.spans.method:=This._tag($t4d.methods; "#000088"; True)
	This.spans.memberFunction:=This._tag($t4d.memberFunc; "#5F8E5E"; False)
	This.spans.member:=This._tag($t4d.member; "#A0806B"; False)
	This.spans.type:=This.spans.command  // types have no dedicated theme token

	// Basic 4D keywords, lowercased (matched case-insensitively, whole word only)
	This.keywords:=["if"; "else"; "end"; "for"; "each"; "while"; "repeat"; "until"; "case"; "of"; "return"; "break"; "continue"; "use"; "var"; "function"; "class"; "constructor"; "extends"; "property"; "singleton"; "shared"; "this"; "super"; "true"; "false"; "null"]

	// Basic types, lowercased (var / property / parameter declarations)
	This.types:=["text"; "date"; "time"; "boolean"; "integer"; "real"; "pointer"; "picture"; "blob"; "collection"; "variant"; "object"]

// Default color for regular text, from the theme style object if valid
Function _color($style : Object; $default : Text)->$color : Text
	$color:=$default
	If ($style#Null)
		If (Length(String($style.color))>0)
			$color:=$style.color
		End if
	End if

// Build the opening <span> tag for a theme style object
Function _tag($style : Object; $defaultColor : Text; $defaultBold : Boolean)->$tag : Text
	var $color : Text
	$color:=$defaultColor
	var $bold : Boolean
	$bold:=$defaultBold
	var $italic; $underline : Boolean
	If ($style#Null)
		If (Length(String($style.color))>0)
			$color:=$style.color
		End if
		If ($style.style#Null)
			$bold:=Bool($style.style.bold)
			$italic:=Bool($style.style.italic)
			$underline:=Bool($style.style.underline)
		End if
	End if
	$tag:="<span style=\"color:"+$color
	If ($bold)
		$tag:=$tag+";font-weight:bold"
	End if
	If ($italic)
		$tag:=$tag+";font-style:italic"
	End if
	If ($underline)
		$tag:=$tag+";text-decoration:underline"
	End if
	$tag:=$tag+"\">"

/**
 * Colorize a line of (tokenized) 4D code as multi-style text.
 * Recognizes: comments, strings, $locals, <>interprocess variables,
 * commands (name:Cnnn, multiword), constants (name:Knn:nn),
 * keywords, basic types, method calls foo(...), member calls .foo(...),
 * object properties .foo and property declaration names.
 */
Function highlight($code : Text)->$styled : Text
	// Escape HTML-significant characters once, then scan the escaped text verbatim.
	var $esc : Text
	$esc:=Replace string($code; "&"; "&amp;")
	$esc:=Replace string($esc; "<"; "&lt;")
	$esc:=Replace string($esc; ">"; "&gt;")

	var $wordChars : Text
	$wordChars:="_abcdefghijklmnopqrstuvwxyz0123456789"  // case-insensitive match
	var $digits : Text
	$digits:="0123456789"
	var $len : Integer
	$len:=Length($esc)
	var $i; $j; $k; $p; $d; $firstEnd; $runEnd : Integer
	var $c; $word; $spanTag : Text
	var $scanning; $isCall; $afterDot; $lineStart; $propertyLine : Boolean

	$styled:=""
	$i:=1
	$lineStart:=True
	$propertyLine:=False
	While ($i<=$len)
		$c:=$esc[[$i]]
		Case of
			: (($c="/") && ($i<$len) && ($esc[[$i+1]]="/"))  // line comment → end of line
				$styled:=$styled+This.spans.comment+Substring($esc; $i)+"</span>"
				$i:=$len+1

			: ($c="\"")  // string literal
				$j:=$i+1
				$scanning:=True
				While ($scanning && ($j<=$len))
					Case of
						: ($esc[[$j]]="\"")  // closing quote
							$scanning:=False
						: ($esc[[$j]]="\\")  // skip escaped char
							$j:=$j+2
						Else
							$j:=$j+1
					End case
				End while
				$styled:=$styled+This.spans.string+Substring($esc; $i; $j-$i+1)+"</span>"
				$i:=$j+1

			: ($c="$")  // local variable / parameter
				$k:=$i+1
				While (($k<=$len) && (Position($esc[[$k]]; $wordChars)>0))
					$k:=$k+1
				End while
				If ($k>($i+1))
					$styled:=$styled+This.spans.localVariable+Substring($esc; $i; $k-$i)+"</span>"
				Else
					$styled:=$styled+$c
				End if
				$i:=$k

			: (($c="&") && (Substring($esc; $i; 8)="&lt;&gt;"))  // interprocess variable <>name
				$k:=$i+8
				While (($k<=$len) && (Position($esc[[$k]]; $wordChars)>0))
					$k:=$k+1
				End while
				If ($k>($i+8))
					$styled:=$styled+This.spans.interprocessVariable+Substring($esc; $i; $k-$i)+"</span>"
				Else
					$styled:=$styled+Substring($esc; $i; 8)  // lone <> comparison
				End if
				$i:=$k

			: (Position($c; $wordChars)>0)  // word: command run, constant, keyword, call…
				$k:=$i+1
				While (($k<=$len) && (Position($esc[[$k]]; $wordChars)>0))
					$k:=$k+1
				End while
				$firstEnd:=$k

				// look ahead through space-separated words for a :Cnnn / :Knn:nn token suffix
				// (tokenized source: "DOM Find XML element:C864", "On Load:K2:1")
				$runEnd:=0
				$spanTag:=""
				$p:=$firstEnd
				$scanning:=True
				While ($scanning)
					Case of
						: (($p<$len) && ($esc[[$p]]=":") && (($esc[[$p+1]]="C") || ($esc[[$p+1]]="K")))
							$d:=$p+2
							While (($d<=$len) && (Position($esc[[$d]]; $digits)>0))
								$d:=$d+1
							End while
							If ($d>($p+2))  // at least one digit after :C / :K
								If ($esc[[$p+1]]="K")
									// constants have a second numeric part (:K37:80)
									If (($d<$len) && ($esc[[$d]]=":") && (Position($esc[[$d+1]]; $digits)>0))
										$d:=$d+2
										While (($d<=$len) && (Position($esc[[$d]]; $digits)>0))
											$d:=$d+1
										End while
									End if
									$spanTag:=This.spans.constant
								Else
									$spanTag:=This.spans.command
								End if
								$runEnd:=$d
							End if
							$scanning:=False
						: (($p<$len) && ($esc[[$p]]=" ") && (Position($esc[[$p+1]]; $wordChars)>0))
							$p:=$p+1  // continue multiword run
							While (($p<=$len) && (Position($esc[[$p]]; $wordChars)>0))
								$p:=$p+1
							End while
						Else
							$scanning:=False
					End case
				End while

				If ($runEnd>0)
					$styled:=$styled+$spanTag+Substring($esc; $i; $runEnd-$i)+"</span>"
					$i:=$runEnd
				Else
					$word:=Substring($esc; $i; $firstEnd-$i)
					$isCall:=($firstEnd<=$len) && ($esc[[$firstEnd]]="(")
					$afterDot:=($i>1) && ($esc[[$i-1]]=".") && (Position($word[[1]]; $digits)=0)  // not a decimal part
					Case of
						: ($afterDot && $isCall)
							$styled:=$styled+This.spans.memberFunction+$word+"</span>"
						: ($afterDot)  // object property access
							$styled:=$styled+This.spans.member+$word+"</span>"
						: (This.keywords.indexOf(Lowercase($word))#-1)
							$styled:=$styled+This.spans.keyword+$word+"</span>"
							If ($lineStart && (Lowercase($word)="property"))
								$propertyLine:=True  // following names are property declarations
							End if
						: (This.types.indexOf(Lowercase($word))#-1)
							$styled:=$styled+This.spans.type+$word+"</span>"
						: ($isCall)
							$styled:=$styled+This.spans.method+$word+"</span>"
						: ($propertyLine)  // declared property name
							$styled:=$styled+This.spans.member+$word+"</span>"
						Else
							$styled:=$styled+$word
					End case
					$i:=$firstEnd
				End if

			Else
				$styled:=$styled+$c
				$i:=$i+1
		End case

		// line-context bookkeeping
		Case of
			: ($c="\n")
				$lineStart:=True
				$propertyLine:=False
			: ($c=":")
				$propertyLine:=False  // the declared type follows
				$lineStart:=False
			: (($c#" ") && ($c#"\t"))
				$lineStart:=False
		End case
	End while
