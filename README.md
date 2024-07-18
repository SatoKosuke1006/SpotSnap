## SpotSnap
<img width="700" alt="image" src="app/assets/images/spotsnap_land.png">
<br>


## 目次
- [SpotSnapとは？](#spotsnapとは)
  - [サービスURL](#サービスurl)
  - [サービス概要](#サービス概要)
  - [コンセプト](#コンセプト)
  - [ユーザー層](#ユーザー層)
  - [実装機能](#実装機能)
- [設計書](#設計書)
  - [ER図](#er図)
  - [画面遷移図](#画面遷移図)
- [開発環境](#開発環境)

## SpotSnapとは？

### サービスURL
https://spotsnap-app.com

### テストアカウント
- メールアドレス：test_account_00@tatsu.uk<br>
- パスワード：password!

### サービス概要
SpotSnapを一言で言うと「場所共有に特化したSNSアプリ」です。

ユーザーは風景や食べ物の写真を通して、その場所の魅力を他のユーザーに共有することができます。

インスタグラムに近いように感じますが、このアプリは場所に特化した設計をしており、そこに違いがあります。

例えば、このアプリでは投稿において位置情報との紐付けが必須であり、場所ごとの投稿数やいいね数を確認することができます。

これらの機能によりユーザーは「場所」に関する興味や発見を助けるために、このアプリを使うことができます。

### コンセプト
このアプリを作成しようと思った背景としては、旅行に行く際に場所を調べるのに特化したアプリがなく悩んでいたことがきっかけにあります。

旅行の行き先を決めるときに使用するアプリとしてインスタグラムやTikTokなどが最近だと多いですが、これらのアプリは場所共有に特化しているわけではないためか、場所との紐付けやキーワードでの検索に弱いと感じました。

例えばインスタグラムで「札幌　ラーメン」と調べる際にはそのハッシュタグをつけている場所しか表示されなかったり、TikTokではマップから場所を検索するような機能がありません。

そこでこのアプリでは画像と位置情報の相互関係に重きを置き、投稿をしたい人見たい人とマップ検索で場所を調べたい人が両方使えるような設計を試みました。

具体的には、場所を検索したときにはアプリ内のマップから「特定の場所名」でも「関連するキーワード」でも検索でき、場所を探すことが可能です。他にも気になった投稿からその場所の位置情報をすぐにチェックできるようになっています。

場所を共有・検索したい人たちの目線でインスタグラムとGoogleマップの機能を複合させるようなものをイメージして作成しました。

### ユーザー層
「お気に入りの場所を共有したい！」
自分のよく行く場所、初めて行って感動した場所、そういった場所を思い出と共に他の人にも共有したいという方

「旅行に行くから情報収集したい！」
旅行先で行く予定の場所で、色んなキーワードで検索したり、特定の場所の雰囲気を知りたいという方

「暇なときに旅行雑誌のように見たい！」
特別行く予定があるわけではないが、暇なときに場所を探して、出かけるときのためにストックしておきたい人

### 実装機能
- アカウント登録機能
- ログイン機能
- 管理者機能（ユーザー削除）
- メール認証機能
- パスワードリセット機能
- ホーム
  - いいねごとの投稿一覧
  - 自分のした投稿一覧
  - いいね機能
- 投稿画面
  - プレビュー機能
  - 画像比選択機能
- ユーザー検索画面
- マップ画面
  - 投稿の位置情報表示機能
  - オートコンプリート機能
  - キーワード検索機能
- 場所ごとの投稿詳細画面
  - 住所/投稿数/いいね数の表示
- プロフィール画面
  - いいねごとの投稿一覧
  - 自分のした投稿一覧

 ### 実装予定の機能
- いいね数と投稿数を用いたステータス機能
  - いいね数が多く、投稿数の少ない投稿→穴場スポット
  - いいね数も稿数数も多い投稿→人気スポット
- マップ上のウィンドゥにいいね数の最も多い画像を表示させる機能
- 場所ごとに画像を必ず載せる機能
  - 投稿画像のみでなく、GoogleMapが持っているデータを使う？
- 投稿コメント機能
- Googleアカウントによるログイン機能
- 投稿時の画像複数選択機能
- プロフィール画像選択機能

## 設計書
### ER図
<img width="700" alt="image" src="app/assets/images/er.png">
<br>

### 画面遷移図
<img width="700" alt="image" src="app/assets/images/screen_flow.png">
<br>

https://www.figma.com/design/24geQAQ7M3fw5KxlOB68aD/Untitled?node-id=0-1&t=WnkvDUZmMRHQPR8M-1

## 開発環境

| カテゴリ       | 使用技術                                                                 |
| -------------- | ------------------------------------------------------------------------ |
| フロントエンド | JavaScript                                                               |
| バックエンド   | Ruby <br> Ruby on Rails                                                  |
| データベース   | PostgreSQL                                                               |
| インフラ       | AWS (ECR, ECS, RDS, SES, S3, Route53, EC2)                               |
| テスト         | GitHub Actions (CI)                                                      |
| API            | Geocoding API <br> Maps JavaScript API <br> Geolocation API <br> Places API |
| その他         | Docker <br> Bootstrap <br> Cursor                                        |
