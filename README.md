# 4d-plugin-scard-v3
スマートカードAPI

### macOSプラットフォーム使用上の注意

プラグインは，内部的に[TKSmartCardSlotManager](https://developer.apple.com/documentation/cryptotokenkit/tksmartcardslotmanager?language=objc)クラスを使用しています。このAPIまたはPCSC Framworkを公証サンドボックスアプリで使用するためには，[com.apple.security.smartcard](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_smartcard?language=objc)エンタイトルメント付きでアプリがコード署名されていなければなりません。エンタイトルメントは，プラグインではなく，アプリ本体側のコード署名に含まれている必要があります。エンタイトルメント付きでアプリをコード署名する方法については[コード署名ツール](https://github.com/miyako/4d-class-build-application)を参照してください。

* SONY PaSoRi RC-S310,RC-S320, RC-S330 (RC-S360, RC-S370): [libpafe](https://github.com/rfujita/libpafe)で対応
* SONY PaSoRi RC-S380 [macOSは非サポート](https://www.sony.co.jp/Products/felica/consumer/support/faq/detail/253.html)なのでLIBUSBで対応
* SONY PaSoRi RC-S300 11月11日発売予定
