//%attributes = {"invisible":true,"preemptive":"capable"}
C_COLLECTION:C1488($0)

If (Storage:C1525.StationCode=Null:C1517)
	Use (Storage:C1525)
		$StationCode:=New shared collection:C1527
		Storage:C1525.StationCode:=$StationCode
	End use 
	$csvFile:=Folder:C1567(fk resources folder:K87:11).folder("csv").file("StationCode.csv")
	$csv:=$csvFile.getText("windows-31j";Document with CR:K24:21)
	
	ARRAY TEXT:C222($lines;0)
	ARRAY TEXT:C222($values;0)
	
	ARRAY LONGINT:C221($pos;0)
	ARRAY LONGINT:C221($len;0)
	
	$i:=0x0001
	  //read lines
	While (Match regex:C1019("([^\\r]+)";$csv;$i;$pos;$len))
		$line:=Substring:C12($csv;$pos{1};$len{1})
		APPEND TO ARRAY:C911($lines;$line)
		$i:=$pos{1}+$len{1}
	End while 
	  //read CSV line
	Use ($StationCode)
		$props:=New collection:C1472
		For ($i;1;Size of array:C274($lines))
			$line:=$lines{$i}
			CLEAR VARIABLE:C89($values)
			$j:=0x0001
			While (Match regex:C1019("(([^,]*),)";$line;$j;$pos;$len))
				$value:=Substring:C12($line;$pos{2};$len{2})
				APPEND TO ARRAY:C911($values;$value)
				$j:=$pos{1}+$len{1}
			End while 
			$value:=Substring:C12($line;$j)
			APPEND TO ARRAY:C911($values;$value)
			If ($props.length=0)
				ARRAY TO COLLECTION:C1563($props;$values)
			Else 
				$elem:=0
				$stationObject:=New shared object:C1526
				$StationCode.push($stationObject)
				Use ($stationObject)
					For each ($prop;$props)
						$elem:=$elem+1
						$stationObject[$prop]:=$values{$elem}
					End for each 
				End use 
			End if 
		End for 
	End use 
Else 
	$StationCode:=Storage:C1525.StationCode
End if 

$0:=$StationCode