# 4d-plugin-scard-v3
スマートカードAPI

### macOSプラットフォーム使用上の注意

プラグインは，内部的に[TKSmartCardSlotManager](https://developer.apple.com/documentation/cryptotokenkit/tksmartcardslotmanager?language=objc)クラスを使用しています。このAPIまたはPCSC Framworkを公証サンドボックスアプリで使用するためには，[com.apple.security.smartcard](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_smartcard?language=objc)エンタイトルメント付きでアプリがコード署名されていなければなりません。エンタイトルメントは，プラグインではなく，アプリ本体側のコード署名に含まれている必要があります。エンタイトルメント付きでアプリをコード署名する方法については[コード署名ツール](https://github.com/miyako/4d-class-build-application)を参照してください。

* SONY PaSoRi RC-S310,RC-S320, RC-S330 (RC-S360, RC-S370): [libpafe](https://github.com/rfujita/libpafe)+libusbで対応
* SONY PaSoRi [RC-S380](https://www.sony.co.jp/Products/felica/consumer/support/faq/detail/253.html): [libusb](https://github.com/libusb/libusb)で対応
* SONY PaSoRi RC-S300 11月11日発売予定: TKSmartCardSlotManagerで対応予定

#### SONY PasoRiのデバイス名について

* USBのデバイス名: Sony RC-S380/P
* `SCardListReaders`のデバイス名: Sony FeliCa Port/PaSoRi 3.0 0

---

<img width="1104" alt="スクリーンショット 2021-11-05 16 48 56" src="https://user-images.githubusercontent.com/1725068/140476325-73319d2e-2af2-40f4-9012-647e1a225102.png">

#### 参考記事

* [プロデルで交通系ICカード履歴ビューアを作る](https://wp.utopiat.net/2017/08/305/)

