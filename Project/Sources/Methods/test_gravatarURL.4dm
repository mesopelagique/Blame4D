//%attributes = {}

var $url : Text

$url:=gravatarURL("MyEmailAddress@example.com")

ASSERT:C1129(Position:C15("0bc83cb571cd1c50ba6f3e8a78ef1346"; $url)>0)

$url:=gravatarURL("<MyEmailaddress@example.com>")
ASSERT:C1129(Position:C15("0bc83cb571cd1c50ba6f3e8a78ef1346"; $url)>0)

var $s : Integer
$s:=10

var $pictureBlob : Blob
HTTP Get:C1157($url+"?s="+String:C10($s)+"&f=y"; $pictureBlob)

var $picture : Picture
BLOB TO PICTURE:C682($pictureBlob; $picture)

var $width; $height : Integer
PICTURE PROPERTIES:C457($picture; $width; $height)

ASSERT:C1129($width=$s)
ASSERT:C1129($height=$s)