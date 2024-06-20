# Pasha-niture <ここにロゴいれる>

#### ぱしゃっと検索、かしゃっと出品

## 概要

<100文字程度で>

<プレゼン資料URL?>

## 環境構築

### backend

Dockerコンテナを立ち上げる。

```bash
$ cd backend 
$ docker-compose up --build
```

以下のようにcurlを叩き、`API is running`と返却されたらバックエンドは完了。

```bash
$ curl http://localhost:8080/ok
{"msg":"API is running"}%
```

もしデモデータを入れたい場合はコンテナが起動した状態で以下を打つ。

```bash
$ docker-compose exec backend-app python -m openapi_server.migrate_db
```

### client



## 技術構成

<使用技術のスライドとかER図などなど>
