//%attributes = {}
$StationCode:=StationCode 

$stations:=$StationCode.query("LineCode == :1 and StationCode == :2";"2";"1")

If ($stations.length#0)
	
	$station:=$stations[0]
	
	$stationName:=New collection:C1472($station.LineName;"線";$station.StationName;"駅").join()
	
End if 
