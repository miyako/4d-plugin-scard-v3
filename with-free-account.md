### 無料メンバーシップでコード署名

[Apple Developer Program](https://developer.apple.com/jp/support/compare-memberships/)のメンバーシップには

* Apple IDでサインイン
* Apple Developer Program
* その他のプログラム

があり，基本の「Apple IDでサインイン」であれば費用は**無料**です。

有料のメンバーシップであれば，`5`種類の証明書が発行できます。

* Apple Development
* Apple Distribtution
* Mac Installer Distribtution
* Developer ID Application
* Developer ID Installer

特典「Mac App Store以外でのソフトウェア配信」にはDeveloper ID Applicationを使用します。

特典「App StoreでのApp配信」にはApple Distribtutionを使用します。

では，無料メンバーシップでコード署名できるのでしょうか。

<img width="830" alt="ss" src="https://user-images.githubusercontent.com/1725068/148340588-cd7ce478-2b67-497a-b0e4-212fa412c0b4.png">

無料のApple IDを追加します。

<img width="830" alt="1" src="https://user-images.githubusercontent.com/1725068/148341384-c9077460-1bd3-4294-b7e4-af76148e62e4.png">

Manage Certificatesをクリックします。

<img width="830" alt="s" src="https://user-images.githubusercontent.com/1725068/148341036-67f71d89-b120-4659-97a3-34256b2d0d23.png">

左下の追加ボタンをクリックします。

<img width="830" alt="2" src="https://user-images.githubusercontent.com/1725068/148341364-b16fbefc-973f-481a-b46d-0d0024786bc7.png">

唯一，Apple Developmentタイプの証明書だけが作成できます。

<img width="830" alt="3" src="https://user-images.githubusercontent.com/1725068/148341337-1875360a-1a3c-43cb-befe-d7d11d01bf55.png">

---

[コード署名ツール](https://github.com/miyako/4d-class-build-application)の[`/SignApp`](https://github.com/miyako/4d-class-build-application/blob/main/Project/Sources/Classes/SignApp.4dm)クラスは，キーチェーン内で`"Developer ID Application:@"`に合致する証明書を検索するようになっています。この部分を`"Apple Development:@"`に書き換えましょう。もし，複数のApple IDを使用していれば，さらに条件を絞って検索します。`Apple Development: info-jp@4d.com (2MMJCMYW5G)`に`Apple Development: info-jp@4d.com (2MMJCMYW5G)`のような文字列が返されるはずです。

あとは通常と同じ要領で目標のアプリをコード署名します。

```4d
$credentials:=New object
$credentials.username:="info-jp@4d.com"
$credentials.password:="**************"
$signApp:=cs.SignApp.new($credentials)

$app:=Folder("Macintosh HD:Applications:4D v19.1:4D.app:"; fk platform path)

$statuses:=$signApp.sign($app)
$status:=$signApp.archive($app)

If ($status.success)
	$status:=$signApp.notarize($status.file)
End if 
```
