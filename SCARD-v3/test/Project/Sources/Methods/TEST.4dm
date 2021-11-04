//%attributes = {}
/*

the 4D app must have the 

com.apple.security.smartcard

entitlement

https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_smartcard

to sign with entitlement

* download https://github.com/miyako/4d-class-build-application
* open method TEST_sign
* update parameters

```4d
$credentials:=New object
$credentials.username:="keisuke.miyako@4d.com"  //apple ID
$credentials.password:="@keychain:altool"  //app specific password or keychain label
$signApp:=cs.SignApp.new($credentials)
$app:=Folder("Macintosh HD:Applications:4D v18.5:Hotfix 3:4D.app:"; fk platform path)
$statusus:=$signApp.sign($app)
$status:=$signApp.archive($app)
If ($status.success)
$status:=$signApp.notarize($status.file)
End if 
```

*/

$status:=SCARD Get readers ($options)

If ($status.success)
	
	$names:=New collection:C1472("Sony PaSoRi RC-S330";"Sony PaSoRi RC-S380")
	
	$readers:=$status.readers.query("slotName in :1";$names)
	
	If ($readers.length#0)
		
/*
		
async API
		
use status.uuid to check results
		
*/
		
		$params:=New object:C1471
		$params.slotName:=$readers[0].slotName
		$params.timeout:=120  //seconds; default=60
		$params.card:="FeliCa"  //FeliCa,TypeB,TypeA
		
		$status:=SCARD Read tag ($params)
		
		Repeat 
			
			$status:=SCARD Get status ($status.uuid)
			
		Until ($status.complete)
		
		If ($status.success)
			ALERT:C41($status.IDm+":"+$status.PMm)
		Else 
			ALERT:C41("ERROR!")
		End if 
		
	End if 
	
End if 