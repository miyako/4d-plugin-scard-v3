//%attributes = {}
/*

the 4D app must have the 

com.apple.security.smartcard

entitlement

https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_smartcard

tool to sign with entitlement

https://github.com/miyako/4d-class-build-application

entitlementが不足している場合はstatusにwarningが出力されます。
Sony PaSoRiはUSBダイレクトなので使用できるかもしれません。

*/

  //https://jorublog.site/raspi-ic-card-reader-install/

C_OBJECT:C1216($1)

If (Count parameters:C259=0)
	
	CALL WORKER:C1389(1;Current method name:C684;New object:C1471)
	
Else 
	
	$window:=Open form window:C675("TEST")
	DIALOG:C40("TEST";*)
	
End if 