// Wraps the git command line for the current database repository.
// Singleton: cs.Git.me
// Replaces the former gitPath / gitGuiPath / gitRemoteURL / blameMethod / blame /
// commitURL / fileForMethod methods.

singleton Class constructor()

	// --- executables ---

	// Path to the git executable.
Function get path()->$path : Text
	If (Is Windows)
		$path:="git.exe"
	Else
		$path:=(File("/usr/local/bin/git").exists) ? "/usr/local/bin/git" : "git"  // prefer user-installed over OS one
	End if

	// Path to the git-gui executable.
Function get guiPath()->$path : Text
	If (Is Windows)
		$path:="git-gui.exe"
	Else
		$path:=(File("/usr/local/bin/git-gui").exists) ? "/usr/local/bin/git-gui" : "git-gui"
	End if

	// --- remote ---

	// URL of the "origin" remote ("" if none).
Function get remoteURL()->$url : Text
	$url:=This._trim(This._run("config --get remote.origin.url"))

	// Hosting service of a remote URL: "GitHub", "GitLab" or "".
Function hostOf($remoteURL : Text)->$host : Text
	Case of
		: (Position("github"; $remoteURL)>0)
			$host:="GitHub"
		: (Position("gitlab"; $remoteURL)>0)
			$host:="GitLab"
		Else
			$host:=""
	End case

	// Web URL of a commit for a remote (GitHub / GitLab), "" if the host is not recognized.
Function commitURL($remoteURL : Text; $hash : Text)->$url : Text
	var $remote : Text
	$remote:=This._trim($remoteURL)
	If ((Length($remote)=0) || (Length($hash)=0))
		return
	End if

	// normalize to a https base: drop scheme, convert scp form, drop userinfo and trailing .git
	var $base : Text
	$base:=$remote
	var $scheme : Integer
	$scheme:=Position("://"; $base)
	If ($scheme>0)
		$base:=Substring($base; $scheme+3)  // host[:port]/owner/repo(.git)
	Else
		var $colon : Integer  // scp syntax: [user@]host:owner/repo(.git)
		$colon:=Position(":"; $base)
		If ($colon>0)
			$base:=Substring($base; 1; $colon-1)+"/"+Substring($base; $colon+1)
		End if
	End if

	var $at : Integer  // strip leading userinfo "user@"
	$at:=Position("@"; $base)
	If ($at>0)
		$base:=Substring($base; $at+1)
	End if

	If ((Length($base)>=4) && (Substring($base; Length($base)-3)=".git"))
		$base:=Substring($base; 1; Length($base)-4)
	End if
	If ((Length($base)>0) && ($base[[Length($base)]]="/"))
		$base:=Substring($base; 1; Length($base)-1)
	End if
	$base:="https://"+$base

	Case of
		: (This.hostOf($remote)="GitHub")
			$url:=$base+"/commit/"+$hash
		: (This.hostOf($remote)="GitLab")
			$url:=$base+"/-/commit/"+$hash
		Else
			$url:=""  // unknown host
	End case

	// --- blame ---

	// git blame (porcelain) of a 4D method, as a cs.Blame object.
Function blameMethod($methodPath : Text; $lines : Text)->$blame : cs.Blame
	var $file : Text
	$file:=This._fileForMethod($methodPath)

	var $options : Text
	If (Count parameters>1)
		$options:=" -L "+$lines
	End if
	var $ignoreRevs : 4D.File
	$ignoreRevs:=Folder(fk database folder; *).file(".git-ignore-revs-file")
	If ($ignoreRevs.exists)
		$options:=$options+" --ignore-revs-file '"+$ignoreRevs.path+"'"
	End if

	// see https://git-scm.com/docs/git-blame
	$blame:=This.blame(This._run("blame"+$options+" -p '"+$file+"'"))

	// Parse git blame porcelain text into a cs.Blame object.
Function blame($output : Text)->$blame : cs.Blame
	$blame:=cs.Blame.new($output)

	// Open git-gui blame for a 4D method (see https://git-scm.com/docs/git-gui).
Function guiBlameMethod($methodPath : Text)
	var $file : Text
	$file:=This._fileForMethod($methodPath)
	SET ENVIRONMENT VARIABLE("_4D_OPTION_CURRENT_DIRECTORY"; Folder(fk database folder; *).platformPath)
	var $in; $out; $err : Text
	LAUNCH EXTERNAL PROCESS(This.guiPath+" blame '"+$file+"'"; $in; $out; $err)

	// --- internals ---

	// Run a git command in the database folder, return its standard output.
Function _run($args : Text)->$out : Text
	SET ENVIRONMENT VARIABLE("_4D_OPTION_CURRENT_DIRECTORY"; Folder(fk database folder; *).platformPath)
	var $in; $err : Text
	LAUNCH EXTERNAL PROCESS(This.path+" "+$args; $in; $out; $err)

	// Remove carriage-return / line-feed characters.
Function _trim($text : Text)->$trimmed : Text
	$trimmed:=Replace string($text; Char(Carriage return); "")
	$trimmed:=Replace string($trimmed; Char(Line feed); "")

	// Map a 4D method path to its source file path (relative to the database folder).
Function _fileForMethod($methodPath : Text)->$file : Text
	var $members : Collection
	Case of
		: (Position("[databaseMethod]/"; $methodPath)=1)
			$file:="Project/Sources/DatabaseMethods/"+Substring($methodPath; 18)+".4dm"
		: (Position("[class]/"; $methodPath)=1)
			$file:="Project/Sources/Classes/"+Substring($methodPath; 9)+".4dm"
		: (Position("[projectForm]/"; $methodPath)=1)
			$members:=Split string($methodPath; "/")
			If (Position("{formMethod}"; $methodPath)>0)
				$file:="Project/Sources/Forms/"+$members[1]+"/method.4dm"
			Else
				$file:="Project/Sources/Forms/"+$members[1]+"/ObjectMethods/"+$members[2]+".4dm"
			End if
		Else
			$file:="Project/Sources/Methods/"+$methodPath+".4dm"
	End case
