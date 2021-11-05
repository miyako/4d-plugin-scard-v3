$event:=FORM Event:C1606

Case of 
	: ($event.code=On Load:K2:1)
		
		Form:C1466.name:=Current form name:C1298
		Form:C1466.window:=Current form window:C827
		Form:C1466.worker:=New collection:C1472(Form:C1466.name;"@";Form:C1466.window).join()
		Form:C1466.workerMethod:="TEST_w"
		
		CALL WORKER:C1389(Form:C1466.worker;Form:C1466.workerMethod;Form:C1466)
		
	: ($event.code=On Unload:K2:2)
		
		KILL WORKER:C1390(Form:C1466.worker)
		
End case 