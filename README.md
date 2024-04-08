## Zero Steps
### サービス概要
ゼロ高等学院の生徒向けの目標共有サービスです。
目標を決め、タスクに分けることで交流しながら目標を達成していけるアプリになります。

また、ログインにはDiscordアカウントが必要ですのでご注意ください

### 主な機能の説明
#### 目標
目標を決めて、登録することができます。
[![Image from Gyazo](https://i.gyazo.com/d6fcaefc723d3d42dd775d6a012e9fbf.png)](https://gyazo.com/d6fcaefc723d3d42dd775d6a012e9fbf)

#### タスク
目標にはタスクを作成することが可能です。
これらをこなしていくことで、目標が近づいていきます

[![Image from Gyazo](https://i.gyazo.com/0038488399fd559632362c892af8d4c1.png)](https://gyazo.com/0038488399fd559632362c892af8d4c1)

#### コメント
目標やタスクにコメントで応援することができます。
メンション機能などもあるので、コメントで通知をすることも可能です

[![Image from Gyazo](https://i.gyazo.com/bc38b8005ba483c24d75e18b7f13a7a2.png)](https://gyazo.com/bc38b8005ba483c24d75e18b7f13a7a2)

#### ユーザーの非公開モード
企業の方など非公開にすることができます。  
初ログイン後の質問にチェックを入れてください

[![Image from Gyazo](https://i.gyazo.com/b214e3ed021ed9c464144e71437bb44e.png)](https://gyazo.com/b214e3ed021ed9c464144e71437bb44e)

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
### 起動
```
$ rails s -b 0.0.0.0 -p 3000
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
