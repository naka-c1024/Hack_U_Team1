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
from openapi_server.models.error_response import ErrorResponse
from openapi_server.models.request_trade_request import RequestTradeRequest
from openapi_server.models.trade_list_response import TradeListResponse
from openapi_server.models.trade_response import TradeResponse
from openapi_server.models.update_approval_request import UpdateApprovalRequest
from openapi_server.models.update_is_checked_request import UpdateIsCheckedRequest

from openapi_server.impl.trade_api_impl import TradeApiImpl
from sqlalchemy.ext.asyncio import AsyncSession
from openapi_server.db import get_db

impl = TradeApiImpl()

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
    db: AsyncSession = Depends(get_db),
) -> TradeListResponse:
    return await impl.trades_get(user_id, db)


@router.post(
    "/trades",
    responses={
        200: {"description": "Trade requested successfully"},
        400: {"model": ErrorResponse, "description": "validation error"},
    },
    tags=["Trade"],
    summary="Request a trade",
    response_model_by_alias=True,
)
async def trades_post(
    request_trade_request: RequestTradeRequest = Body(None, description=""),
    db: AsyncSession = Depends(get_db),
) -> None:
    return await impl.trades_post(request_trade_request, db)


@router.get(
    "/trades/{trade_id}",
    responses={
        200: {"model": TradeResponse, "description": "Trade details retrieved successfully"},
        400: {"model": ErrorResponse, "description": "validation error"},
    },
    tags=["Trade"],
    summary="Get trade details",
    response_model_by_alias=True,
)
async def trades_trade_id_get(
    trade_id: int = Path(..., description=""),
    db: AsyncSession = Depends(get_db),
) -> TradeResponse:
    return await impl.trades_trade_id_get(trade_id, db)


@router.put(
    "/trades/{trade_id}/isChecked",
    responses={
        200: {"description": "Trade status updated successfully"},
        400: {"model": ErrorResponse, "description": "validation error"},
    },
    tags=["Trade"],
    summary="Update isChecked status",
    response_model_by_alias=True,
)
async def trades_trade_id_is_checked_put(
    trade_id: int = Path(..., description=""),
    update_is_checked_request: UpdateIsCheckedRequest = Body(None, description=""),
    db: AsyncSession = Depends(get_db),
) -> None:
    return await impl.trades_trade_id_is_checked_put(trade_id, update_is_checked_request, db)


@router.put(
    "/trades/{trade_id}",
    responses={
        200: {"description": "Trade status updated successfully"},
        400: {"model": ErrorResponse, "description": "validation error"},
    },
    tags=["Trade"],
    summary="Update approval status",
    response_model_by_alias=True,
)
async def trades_trade_id_put(
    trade_id: int = Path(..., description=""),
    update_approval_request: UpdateApprovalRequest = Body(None, description=""),
    db: AsyncSession = Depends(get_db),
) -> None:
    return await impl.trades_trade_id_put(trade_id, update_approval_request, db)