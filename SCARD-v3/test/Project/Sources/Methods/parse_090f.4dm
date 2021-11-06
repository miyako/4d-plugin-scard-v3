//%attributes = {"invisible":true,"preemptive":"capable"}
C_TEXT:C284($1)
C_OBJECT:C1216($0;$obj)

$data:=$1
$端末種:=$2
$処理:=$3

C_BLOB:C604($bytes)
SET BLOB SIZE:C606($bytes;16)
$byte:=Formula:C1597(Position:C15($1;"0123456789abcdef";*)-1)
$len:=Length:C16($data)
If (($len%2)=0)
	For ($i;1;$len;2)
		$hex:=Substring:C12($data;$i;2)
		$bytes{$i\2}:=($byte.call(Null:C1517;$hex[[1]]) << 4)+$byte.call(Null:C1517;$hex[[2]])
	End for 
	
	$obj:=New object:C1471
	
	$term:=$端末種[$bytes{0}]
	$proc:=$処理[$bytes{1}]
	
	$obj.端末種:=$term
	$obj.処理:=$proc
	
	$year:=($bytes{4} >> 1)+2000
	$month:=(($bytes{4} & 1) << 3)+($bytes{5} >> 5)
	$day:=$bytes{5} & (1 << 5)-1
	$date:=Add to date:C393(!00-00-00!;$year;$month;$day)
	$obj.日付:=$date
	
	$num:=(($bytes{12} << 16)+($bytes{13} << 8)+$bytes{14})  // 連番 (SeqNo)
	$balance:=(($bytes{11} << 8)+$bytes{10})
	$obj.残高:=$balance
	
	Case of 
		: (New collection:C1472(70;73;74;75;198;203).indexOf($bytes{1})#-1)  //shopping
			$hour:=$bytes{6} >> 3
			$min:=(($bytes{6} & 7) << 3)+($bytes{7} >> 5)
			$sec:=($bytes{7} & 0x001F) << 1  //2秒単位
			$time:=Time:C179(($hour*3600)+($min+60)+$sec)
			$reg:=(($bytes{8} << 8)+$bytes{9})  //物販端末ID
			$obj.利用時刻:=Time string:C180($time)
			$obj.利用:="物販"
		: (New collection:C1472(13;15;31;35).indexOf($bytes{1})#-1)  //bus
			$out_line:=($bytes{6} << 8)+$bytes{7}
			$out_sta:=($bytes{8} << 8)+$bytes{9}
			$obj.バス事業者コード:=$out_line
			$obj.バス停留所コード:=$out_sta
			$obj.利用:="バス"
		Else 
			
			$area:=$bytes{5}
			$region_in:=(($bytes{15}) & 0x00C0) >> 6
			$region_out:=(($bytes{15}) & 0x0030) >> 4
			$in_line:=$bytes{6}
			$in_sta:=$bytes{7}
			$out_line:=$bytes{8}
			$out_sta:=$bytes{9}
			
			$obj.入場駅:=get_station_name ($region_in;$in_line;$in_sta)
			$obj.出場駅:=get_station_name ($region_out;$out_line;$out_sta)
			$obj.利用:="鉄道"
	End case 
	
End if 

$0:=$obj