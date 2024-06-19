# coding: utf-8

from typing import Dict, List  # noqa: F401
import importlib
import pkgutil

from openapi_server.apis.user_api_base import BaseUserApi
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
from openapi_server.models.login_request import LoginRequest
from openapi_server.models.login_response import LoginResponse
from openapi_server.models.sign_up_request import SignUpRequest

from openapi_server.impl.user_api_impl import UserApiImpl

from openapi_server.db import get_db
from sqlalchemy.ext.asyncio import AsyncSession

impl = UserApiImpl()

router = APIRouter()

ns_pkg = openapi_server.impl
for _, name, _ in pkgutil.iter_modules(ns_pkg.__path__, ns_pkg.__name__ + "."):
    importlib.import_module(name)


@router.post(
    "/login",
    responses={
        200: {"model": LoginResponse, "description": "User logged in successfully"},
        400: {"model": ErrorResponse, "description": "validation error"},
    },
    tags=["User"],
    summary="User login",
    response_model_by_alias=True,
)
async def login_post(
    login_request: LoginRequest = Body(None, description=""), db: AsyncSession = Depends(get_db)
) -> LoginResponse:
    return await impl.login_post(login_request, db)


@router.post(
    "/logout",
    responses={
        200: {"description": "User logged out successfully"},
    },
    tags=["User"],
    summary="User logout",
    response_model_by_alias=True,
)
async def logout_post(
) -> None:
    return impl.logout_post()


@router.post(
    "/sign_up",
    responses={
        200: {"description": "User registered successfully"},
        400: {"model": ErrorResponse, "description": "validation error"},
    },
    tags=["User"],
    summary="sign up",
    response_model_by_alias=True,
)
async def sign_up_post(
    sign_up_request: SignUpRequest = Body(None, description=""), db: AsyncSession = Depends(get_db)
) -> None:
    return await impl.sign_up_post(sign_up_request, db)
