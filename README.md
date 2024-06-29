# Pasha-niture

<img src=https://github.com/naka-c1024/Pasha-niture/blob/main/client/app/assets/images/logo.png/ width=50%>

#### ぱしゃっと検索、かしゃっと出品

## 概要

**家具専用フリマアプリ**  
写真をパシャっと撮るだけで面倒な家具情報を自動入力。そのまま簡単出品!  
写真をパシャっと撮るだけであなたの部屋の雰囲気にぴったりの家具を提案!  
スマートで楽しい家具選びを体験しよう!

## DEMO

https://github.com/naka-c1024/Pasha-niture/assets/78196739/cc298d4b-07a4-4a02-8de1-548e976fae41

## 環境構築

### backend

#### 環境変数の設定

`backend/.env`ファイルを作成し以下を記述(例)

```
MYSQL_ALLOW_EMPTY_PASSWORD=yes
MYSQL_DATABASE=backend
TZ=Asia/Tokyo

MINIO_ENDPOINT=http://minio:9000
MINIO_ROOT_USER=minio
MINIO_ROOT_PASSWORD=minio-password
MINIO_ACCESS_KEY=minio
MINIO_SECRET_KEY=minio-password
BUCKET_NAME=pasha-niture-bucket
```

#### APIキーの設定

`backend/src/openapi_server/ai/secret.json`ファイルを作成し、以下を記述

```
{
    "OPENAI_API_KEY": "Your API KEY"
}
```

#### Dockerコンテナを立ち上げる

```bash
$ cd backend
$ docker-compose up --build
```

以下のようにcurlを叩き、`API is running`と返却されるか確認

```bash
$ curl http://localhost:8080/ok
{"msg":"API is running"}%
```

#### DBマイグレーションとデモデータの投入

```bash
$ docker-compose exec backend-app python -m openapi_server.migrate.db
```

### client

#### Requirements

- Flutter 3.22.2
- Dart 3.4.3
- iOS 17.5.1

#### ターミナルからビルド
Pasha-niture/client/app/ で以下を実行　
```
flutter run
```
#### XCodeからビルド
Pasha-niture/client/app/ios/Runner.xcworkspace をビルド

## 技術構成

<img width="1029" alt="image" src="https://github.com/naka-c1024/Pasha-niture/assets/78196739/a04c72bb-cadf-4b52-91a2-92f977e0734b">

<img width="1013" alt="image" src="https://github.com/naka-c1024/Pasha-niture/assets/78196739/3d3e539b-4ec9-40e4-a511-ec397cf4057c">

<img width="1002" alt="image" src="https://github.com/naka-c1024/Pasha-niture/assets/78196739/404559f0-7679-48b4-b4b8-0c0f9b53cce1">
