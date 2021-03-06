//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($1;$2)

Case of 
	: (Count parameters:C259=1)
		
		$form:=$1
		
		$status:=SCARD Get readers 
		
		If ($status.success)
			
			If (Is macOS:C1572)
				$readers:=$status.readers.query("slotName == :1";"Sony FeliCa RC-S3@")
			Else 
				$readers:=$status.readers
			End if 
			
			If ($readers.length#0)
				
				$params:=New object:C1471
				$params.slotName:=$readers[0].slotName
				$params.timeout:=3  //seconds; default=60
				$params.card:="FeliCa"  //FeliCa,TypeB,TypeA
				$params.system:=Bool:C1537($form.system)
				
				$status:=SCARD Read tag ($params)
				
				Repeat 
					
					$status:=SCARD Get status ($status.uuid)
					
					DELAY PROCESS:C323(Current process:C322;10)
					
				Until ($status.complete)
				
				CALL FORM:C1391($form.window;Current method name:C684;New object:C1471;$status)
				
			End if 
			
		End if 
		
		If (Not:C34(Process aborted:C672))
			If (Not:C34(Bool:C1537($form.system)))
				CALL WORKER:C1389(Current process name:C1392;Current method name:C684;$form)
			End if 
		End if 
		
	: (Count parameters:C259=2)
		
		$status:=$2
		
		  //%T-
		Form:C1466.slotName:=$status.slotName
		
		If ($status.success)
			If ($status.serviceData#Null:C1517)
				Form:C1466.serviceData:=$status.serviceData
				Form:C1466.info:=map_090f (Form:C1466.serviceData.data)
			End if 
			
			$IDm:=String:C10(Form:C1466.IDm)
			
			Form:C1466.IDm:=$status.IDm
			
			If (Form:C1466.IDm#"") & ($IDm#Form:C1466.IDm)
				
				$form:=OB Copy:C1225(Form:C1466)
				$form.system:=True:C214
				
				If (Not:C34(Process aborted:C672))
					CALL WORKER:C1389(Form:C1466.worker;Current method name:C684;$form)
				End if 
				
			End if 
		Else 
			Form:C1466.IDm:=""
			Form:C1466.serviceData:=Null:C1517
			Form:C1466.info:=Null:C1517
		End if 
		Form:C1466.timestamp:=Timestamp:C1445
		  //%T+
		
End case 