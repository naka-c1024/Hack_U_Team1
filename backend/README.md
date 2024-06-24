# Pasha-niture バックエンド ドキュメント

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

tables.mdを変更した後に、tables.pyも変更すること  
backend-appコンテナが起動した状態で以下のコマンドを打つ


```
docker-compose exec backend-app python -m openapi_server.migrate.db
```

## MySQL

```
docker-compose exec db mysql backend
```
