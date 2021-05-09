//%attributes = {}
#DECLARE($str : Text)->$hexColor : Text

If ($str="0000000000000000000000000000000000000000")
	$hexColor:=""  // color of new change
Else 
	var $hash; $i : Integer
	$hash:=0; 
	For ($i; 1; Length:C16($str); 1)
		$hash:=Character code:C91($str[[$i]])+(($hash << 5)-$hash)
	End for 
	
	$hexColor:="#"+Substring:C12(Uppercase:C13(String:C10($hash & 0x00FFFFFF)); 1; 6)
End if 