//%attributes = {}
// Web URL of a commit for a git remote, for GitHub and GitLab.
// Returns "" if the remote is empty or its host is not recognized.
#DECLARE($remoteURL : Text; $hash : Text)->$url : Text

var $remote : Text
$remote:=Replace string:C233($remoteURL; Char:C90(Carriage return:K15:38); "")
$remote:=Replace string:C233($remote; Char:C90(Line feed:K15:40); "")
If ((Length:C16($remote)=0) || (Length:C16($hash)=0))
	return
End if

// normalize to a https base: drop scheme, convert scp form, drop userinfo and trailing .git
var $base : Text
$base:=$remote
var $scheme : Integer
$scheme:=Position:C15("://"; $base)
If ($scheme>0)
	$base:=Substring:C12($base; $scheme+3)  // host[:port]/owner/repo(.git)
Else
	var $colon : Integer  // scp syntax: [user@]host:owner/repo(.git)
	$colon:=Position:C15(":"; $base)
	If ($colon>0)
		$base:=Substring:C12($base; 1; $colon-1)+"/"+Substring:C12($base; $colon+1)
	End if
End if

var $at : Integer  // strip leading userinfo "user@"
$at:=Position:C15("@"; $base)
If ($at>0)
	$base:=Substring:C12($base; $at+1)
End if

If ((Length:C16($base)>=4) && (Substring:C12($base; Length:C16($base)-3)=".git"))
	$base:=Substring:C12($base; 1; Length:C16($base)-4)
End if
If ((Length:C16($base)>0) && ($base[[Length:C16($base)]]="/"))
	$base:=Substring:C12($base; 1; Length:C16($base)-1)
End if

$base:="https://"+$base
Case of
	: (Position:C15("github"; $remote)>0)
		$url:=$base+"/commit/"+$hash
	: (Position:C15("gitlab"; $remote)>0)
		$url:=$base+"/-/commit/"+$hash
	Else
		$url:=""  // unknown host
End case
