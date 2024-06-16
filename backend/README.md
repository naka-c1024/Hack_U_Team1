# OpenAPI generated FastAPI server

## Requirements.

Python >= 3.7

## Running with Docker

サーバーを起動するには以下を実行:

```bash
docker-compose up --build
```

## Install Packages

`backend/requirements.txt`ファイルにパッケージ名を追加する  
その後以下のコマンドを実行
```
docker-compose build --no-cache
```

もしinstallで依存関係を確認したい場合は、  
backend-appコンテナが起動した状態で以下のコマンドを打つ

```
docker-compose exec backend-app pip install <パッケージ名>
```

## migration

backend-appコンテナが起動した状態で以下のコマンドを打つ

```
docker-compose exec backend-app python -m openapi_server.migrate_db
```

中身の確認

```
docker-compose exec db mysql backend
```

https://zenn.dev/sh0nk/books/537bb028709ab9/viewer/281ee0#%E7%A2%BA%E8%AA%8D
