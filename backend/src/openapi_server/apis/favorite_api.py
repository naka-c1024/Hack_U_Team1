# coding: utf-8

from typing import Dict, List  # noqa: F401
import importlib
import pkgutil

from openapi_server.apis.favorite_api_base import BaseFavoriteApi
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
from openapi_server.models.error_response import ErrorResponse
from openapi_server.models.favorite_response import FavoriteResponse


router = APIRouter()

ns_pkg = openapi_server.impl
for _, name, _ in pkgutil.iter_modules(ns_pkg.__path__, ns_pkg.__name__ + "."):
    importlib.import_module(name)


@router.delete(
    "/favorite",
    responses={
        200: {"description": "Favorite deleted successfully"},
        400: {"model": ErrorResponse, "description": "validation error"},
    },
    tags=["Favorite"],
    summary="Delete favorite",
    response_model_by_alias=True,
)
async def favorite_delete(
    furniture_id: int = Query(None, description="", alias="furniture_id"),
    user_id: int = Query(None, description="", alias="user_id"),
) -> None:
    ...


@router.get(
    "/favorite/{furniture_id}/",
    responses={
        200: {"model": FavoriteResponse, "description": "Favorite status retrieved successfully"},
        400: {"model": ErrorResponse, "description": "validation error"},
    },
    tags=["Favorite"],
    summary="Get favorite status",
    response_model_by_alias=True,
)
async def favorite_furniture_id_get(
    furniture_id: int = Path(..., description=""),
) -> FavoriteResponse:
    ...


@router.post(
    "/favorite",
    responses={
        200: {"description": "Favorite added successfully"},
        400: {"model": ErrorResponse, "description": "validation error"},
    },
    tags=["Favorite"],
    summary="Add favorite",
    response_model_by_alias=True,
)
async def favorite_post(
    furniture_id: int = Query(None, description="", alias="furniture_id"),
    user_id: int = Query(None, description="", alias="user_id"),
) -> None:
    ...
