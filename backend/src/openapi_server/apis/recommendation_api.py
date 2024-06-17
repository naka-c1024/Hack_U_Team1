# coding: utf-8

from typing import Dict, List  # noqa: F401
import importlib
import pkgutil

from openapi_server.apis.recommendation_api_base import BaseRecommendationApi
import openapi_server.impl

from fastapi import (  # noqa: F401
    APIRouter,
    Body,
    Cookie,
    Depends,
    Form,
    Header,
    Path,
    Query,
    Response,
    Security,
    status,
)

from openapi_server.models.extra_models import TokenModel  # noqa: F401
from openapi_server.models.recommend_request import RecommendRequest
from openapi_server.models.recommend_response import RecommendResponse


router = APIRouter()

ns_pkg = openapi_server.impl
for _, name, _ in pkgutil.iter_modules(ns_pkg.__path__, ns_pkg.__name__ + "."):
    importlib.import_module(name)


@router.get(
    "/recommend",
    responses={
        200: {"model": RecommendResponse, "description": "Furniture recommendations retrieved successfully"},
    },
    tags=["Recommendation"],
    summary="Get furniture recommendations based on room photo",
    response_model_by_alias=True,
)
async def recommend_get(
    recommend_request: RecommendRequest = Body(None, description=""),
) -> RecommendResponse:
    ...
