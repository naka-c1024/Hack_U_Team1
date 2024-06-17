# OpenAPI 使用方法

## Swaggerの使い方

### VSCODEの場合(推奨)

SwaggerViewerという拡張機能をインストールすれば簡単に見れる

参考  
https://zenn.dev/nekoniki/articles/acd946cc349d1e

### Dockerの場合

`/openapi`の配下で以下のコマンドを叩く

```
docker-compose up
```

ブラウザから確認

| 名称              | URL                         |
|-------------------|-----------------------------|
| Swagger Editor    | [http://localhost:8001/](http://localhost:8001/) |
| Swagger UI        | [http://localhost:8002/](http://localhost:8002/) |
| Swagger API mock  | [http://localhost:8003/ok](http://localhost:8003/ok) |


参考  
https://qiita.com/A-Kira/items/3d17396c7cc98873e29d

## OpenAPIからFastAPIのコードを自動生成する方法

`backend/.openapi-generator-ignore`に入っていないものは 更新 or 初期化 されてしまうので注意する

下記を行う前に

```
docker run --rm -v ${PWD}:/local -v ${PWD}/../backend:/output openapitools/openapi-generator-cli generate -i /local/openapi.yaml -g python-fastapi -o /output
```
