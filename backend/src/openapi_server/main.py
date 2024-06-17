# coding: utf-8

"""
    家具マッチングサービス

    画像によるレコメンド機能を添えて

    The version of the OpenAPI document: 1.0.0
    Generated by OpenAPI Generator (https://openapi-generator.tech)

    Do not edit the class manually.
"""  # noqa: E501


from fastapi import FastAPI

from openapi_server.apis.favorite_api import router as FavoriteApiRouter
from openapi_server.apis.furniture_api import router as FurnitureApiRouter
from openapi_server.apis.ok_api import router as OKApiRouter
from openapi_server.apis.recommendation_api import router as RecommendationApiRouter
from openapi_server.apis.trade_api import router as TradeApiRouter
from openapi_server.apis.user_api import router as UserApiRouter

app = FastAPI(
    title="家具マッチングサービス",
    description="画像によるレコメンド機能を添えて",
    version="1.0.0",
)

app.include_router(FavoriteApiRouter)
app.include_router(FurnitureApiRouter)
app.include_router(OKApiRouter)
app.include_router(RecommendationApiRouter)
app.include_router(TradeApiRouter)
app.include_router(UserApiRouter)
