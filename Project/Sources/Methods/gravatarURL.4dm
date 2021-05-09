//%attributes = {}
// https://fr.gravatar.com/site/implement/images/
#DECLARE($mail : Text)->$url : Text

var $hash : Text
$hash:=Lowercase:C14($mail)
// XXX trim space 

If (Position:C15("<"; $hash)=1)
	$hash:=Substring:C12($hash; 2)
End if 
If (Position:C15(">"; $hash)=Length:C16($hash))
	$hash:=Substring:C12($hash; 1; Length:C16($hash)-1)
End if 

$hash:=Generate digest:C1147($hash; MD5 digest:K66:1)

$url:="https://www.gravatar.com/avatar/"+$hash
