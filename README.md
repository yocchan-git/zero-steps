## Zero Steps
### サービス概要
一言で言うと、「目標共有サービス」です。
目標を決め、タスクに分けることで交流しながら目標を達成していけるアプリになります。

また、ログインにはDiscordアカウントが必要ですのでご注意ください

### 主な機能の説明
#### ログイン
ログインにはDiscordアカウントが必要です。  
ログインボタンを押して、「認証」をクリックすればログイン完了です！

[![Image from Gyazo](https://i.gyazo.com/0970f6f553246dac126cdafaea5774e7.gif)](https://gyazo.com/0970f6f553246dac126cdafaea5774e7)

#### ユーザー登録
初めてログインした際は、ユーザー登録画面に遷移します。
「自己紹介」を書いたり、非公開設定などの情報を入力して登録するボタンを押してください。

[![Image from Gyazo](https://i.gyazo.com/e53760a4616945557941865dccdbdf41.png)](https://gyazo.com/e53760a4616945557941865dccdbdf41)

#### 目標
目標を決めて、登録することができます。
[![Image from Gyazo](https://i.gyazo.com/66905bf26e5166aff15b1b2f1723e214.gif)](https://gyazo.com/66905bf26e5166aff15b1b2f1723e214)

#### タスク
目標にはタスクを作成することが可能です。
これらをこなしていくことで、目標が近づいていきます

[![Image from Gyazo](https://i.gyazo.com/81ebf0a472f9818d2132398c7e1775bd.gif)](https://gyazo.com/81ebf0a472f9818d2132398c7e1775bd)

#### コメント
目標やタスクにコメントで応援することができます。
メンション機能などもあるので、コメントで通知をすることも可能です

[![Image from Gyazo](https://i.gyazo.com/f9777dbd7932fafab8999484b3ec40bf.gif)](https://gyazo.com/f9777dbd7932fafab8999484b3ec40bf)

## 使用技術
- Ruby 3.2.2
- Ruby on Rails 7.0.8
- bootstrap
- RSpec
- PostgreSQL
- GitHub Actions

## 開発環境の構築
### インストール
```
$ git clone git@github.com:yocchan-git/zero-steps.git
$ cd zero-steps
$ bin/setup
```

### ログインできるようにする
前準備として、`.env.sample`を`.env`の名前でコピーしてください。  
そして、以下の2つの手順で`.env`ファイルを変更してください。

#### 1. Discordの設定キーを取得する
Discordログインする方法をブログ記事に書きました。  
そちらの[手順１](https://qiita.com/yocchan_qiita/items/8527aa1455141c71cc23#1-discord%E3%81%AE%E9%96%8B%E7%99%BA%E8%80%85%E7%94%A8%E7%94%BB%E9%9D%A2%E3%81%A7%E8%A8%AD%E5%AE%9A%E3%82%AD%E3%83%BC%E3%82%92%E5%8F%96%E5%BE%97%E3%81%99%E3%82%8B)を実行し設定キーの取得とリダイレクトURLの設定をしてください。

```.env
# クライアントIDを入れる
DISCORD_CLIENT_ID=

# クライアントシークレットの値を入れる
DISCORD_CLIENT_SECRET=
```

#### 2. botをコメントできるようにする
こちらも別途[記事](https://qiita.com/yocchan_qiita/items/2a586e9b1a41d89579f7)を書いたので、その記事の通りに設定してください。

```.env
# botトークンの値を入れる
DISCORD_BOT_TOKEN=

# チャンネルIDの値を入れる
DISCORD_CHANNEL_ID=
```

必要であればサーバーを再起動してください。
以上でログインできるようになります。

### 起動
```
$ rails s
```

http://localhost:3000 にアクセスする
### テスト
```
# 全て実行する
$ bundle exec rspec

# モデルテストのみの実行
$ bundle exec rspec spec/system

# システムテストのみの実行
$ bundle exec rspec spec/model
```
### フォーマッター
```
$ bundle exec rubocop
$ bundle exec erblint --lint-all
```
