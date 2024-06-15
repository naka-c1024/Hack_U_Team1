# coding: utf-8

from typing import Dict, List  # noqa: F401
import importlib
import pkgutil

from openapi_server.apis.trade_api_base import BaseTradeApi
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
from openapi_server.models.request_trade_request import RequestTradeRequest
from openapi_server.models.trade_list_response import TradeListResponse
from openapi_server.models.update_is_checked_request import UpdateIsCheckedRequest
from openapi_server.models.update_trade_request import UpdateTradeRequest


router = APIRouter()

ns_pkg = openapi_server.impl
for _, name, _ in pkgutil.iter_modules(ns_pkg.__path__, ns_pkg.__name__ + "."):
    importlib.import_module(name)


@router.get(
    "/trades",
    responses={
        200: {"model": TradeListResponse, "description": "Trade list retrieved successfully"},
    },
    tags=["Trade"],
    summary="Get list of trades history",
    response_model_by_alias=True,
)
async def trades_get(
    user_id: int = Query(None, description="", alias="user_id"),
) -> TradeListResponse:
    ...


@router.post(
    "/trades",
    responses={
        200: {"description": "Trade requested successfully"},
        400: {"description": "バリデーションエラー"},
    },
    tags=["Trade"],
    summary="Request a trade",
    response_model_by_alias=True,
)
async def trades_post(
    request_trade_request: RequestTradeRequest = Body(None, description=""),
) -> None:
    ...


@router.put(
    "/trades/{trade_id}/isChecked",
    responses={
        200: {"description": "Trade status updated successfully"},
        400: {"description": "バリデーションエラー"},
    },
    tags=["Trade"],
    summary="Update isChecked status",
    response_model_by_alias=True,
)
async def trades_trade_id_is_checked_put(
    trade_id: int = Path(..., description=""),
    update_is_checked_request: UpdateIsCheckedRequest = Body(None, description=""),
) -> None:
    ...


@router.put(
    "/trades/{trade_id}",
    responses={
        200: {"description": "Trade status updated successfully"},
        400: {"description": "バリデーションエラー"},
    },
    tags=["Trade"],
    summary="Update trade status",
    response_model_by_alias=True,
)
async def trades_trade_id_put(
    trade_id: int = Path(..., description=""),
    update_trade_request: UpdateTradeRequest = Body(None, description=""),
) -> None:
    ...
