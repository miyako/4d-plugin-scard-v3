//%attributes = {}
C_LONGINT:C283($1;$2;$3)
C_TEXT:C284($0)

If ($1=0) & ($2=0) & ($3=0)
	
Else 
	
	$StationCode:=StationCode 
	
	$stations:=$StationCode.query("AreaCode == :1 and LineCode == :2 and StationCode == :3";String:C10($1);String:C10($2);String:C10($3))
	
	If ($stations.length#0)
		$station:=$stations[0]
		$stationName:=New collection:C1472($station.LineName;"線";$station.StationName;"駅").join()
	End if 
	
End if 

$0:=$stationName