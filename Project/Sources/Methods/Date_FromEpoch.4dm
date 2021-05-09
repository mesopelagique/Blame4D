//%attributes = {}
// ----------------------------------------------------
// Method: Date_FromEpoch
// http://blog.heintz.net/a-quick-one-epoch-unix-timestamp-conversion/
// ----------------------------------------------------
// Call:   Timestring:=Date_FromEpoch(Epoch)
// ----------------------------------------------------
//        [ ] theadsafe
// ----------------------------------------------------
// UserName (OS): Alexander Heintz
// Date and Time: 24.03.17, 13:10:11
// ----------------------------------------------------
// Does:
//      returns a timestring (ISO Date) for the Epoch given
//      the timestring returned is in local time zone
// ----------------------------------------------------
// Parameters:
// ->  $1     real     the Epoch to convert
// <-  $0     text        the ISO timestring
// ----------------------------------------------------
// Parameter Definition
C_REAL:C285($1)
C_TEXT:C284($0)
// ----------------------------------------------------
// Local Variable Definition
C_DATE:C307($d_Date)
C_TIME:C306($h_Time)
C_LONGINT:C283($l_Days)
C_LONGINT:C283($l_Seconds)
C_REAL:C285($r_Epoch)
C_TEXT:C284($t_TimeStamp)
// ----------------------------------------------------
// Parameter Assignment
$r_Epoch:=$1
// ----------------------------------------------------
$l_Days:=Trunc:C95($r_Epoch/86400; 0)
$l_Seconds:=Mod:C98($r_Epoch; 86400)
$d_Date:=!1970-01-01!+$l_Days
$h_Time:=Time:C179(Time string:C180($l_Seconds))
$t_TimeStamp:=String:C10($d_Date; ISO date:K1:8; $h_Time)+"Z"
$t_TimeStamp:=String:C10(Date:C102($t_TimeStamp); ISO date:K1:8; Time:C179($t_TimeStamp))
$0:=$t_TimeStamp
