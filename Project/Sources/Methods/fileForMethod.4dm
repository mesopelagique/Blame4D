//%attributes = {}
#DECLARE($methodPath : Text)->$file : Text

Case of 
	: (Position:C15("[databaseMethod]/"; $methodPath)=1)
		$file:="Project/Sources/DatabaseMethods/"+Substring:C12($methodPath; 18)+".4dm"
	: (Position:C15("[class]/"; $methodPath)=1)
		$file:="Project/Sources/Classes/"+Substring:C12($methodPath; 9)+".4dm"
	: (Position:C15("[projectForm]/"; $methodPath)=1)
		If (Position:C15("{formMethod}"; $methodPath)>0)
			$members:=Split string:C1554($methodPath; "/")
			$file:="Project/Sources/Forms/"+$members[1]+"/method.4dm"
		Else 
			var $members : Collection
			$members:=Split string:C1554($methodPath; "/")
			$file:="Project/Sources/Forms/"+$members[1]+"/ObjectMethods/"+$members[2]+".4dm"
		End if 
	Else 
		$file:="Project/Sources/Methods/"+$methodPath+".4dm"
End case 