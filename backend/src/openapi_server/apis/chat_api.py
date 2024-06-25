# coding: utf-8

from typing import Dict, List  # noqa: F401
import importlib
import pkgutil

from openapi_server.apis.chat_api_base import BaseChatApi
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
    WebSocket,
)

from openapi_server.models.extra_models import TokenModel  # noqa: F401
from openapi_server.models.chat_list_response import ChatListResponse
from openapi_server.models.error_response import ErrorResponse
from openapi_server.impl.chat_api_impl import ChatApiImpl
from sqlalchemy.ext.asyncio import AsyncSession
from openapi_server.db import get_db


impl = ChatApiImpl()

router = APIRouter()

ns_pkg = openapi_server.impl
for _, name, _ in pkgutil.iter_modules(ns_pkg.__path__, ns_pkg.__name__ + "."):
    importlib.import_module(name)


@router.get(
    "/chat/{sender_id}/{receiver_id}",
    responses={
        200: {"model": ChatListResponse, "description": "Chat list retrieved successfully"},
        400: {"model": ErrorResponse, "description": "validation error"},
    },
    tags=["Chat"],
    summary="Get chat list",
    response_model_by_alias=True,
)
async def chat_sender_id_receiver_id_get(
    sender_id: int = Path(..., description=""),
    receiver_id: int = Path(..., description=""),
    db: AsyncSession = Depends(get_db),
) -> ChatListResponse:
    return await impl.chat_sender_id_receiver_id_get(sender_id, receiver_id, db)


@router.websocket(
    "/chat/ws/{client_id}",
    )
async def websocket_endpoint(
    websocket: WebSocket,
    client_id: int,
    db: AsyncSession = Depends(get_db),
    ) -> None:
    return await impl.chat_ws_websocket(websocket, client_id, db)
