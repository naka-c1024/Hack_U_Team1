# Pasha-niture バックエンド ドキュメント

## Running with Docker

サーバーを起動するには以下を実行:

```bash
docker-compose up --build
```

## Install Packages

`backend/requirements.txt`ファイルにパッケージ名を追加する  

もしinstallで依存関係を確認したい場合は、  
backend-appコンテナが起動した状態で以下を実行

```
docker-compose exec backend-app pip install <パッケージ名>
```

## DB migration

テーブル定義を変更する場合は、tables.mdを変更した後に、tables.pyを変更すること
backend-appコンテナが起動した状態で以下を実行

```
docker-compose exec backend-app python -m openapi_server.migrate.db
```

## MySQL

```
docker-compose exec db mysql backend -u root -p
```

その後パスワードを求められるので`.env`ファイルに記載されたROOT_PASSWORDを入力
