# coding: utf-8

from typing import Dict, List  # noqa: F401
import importlib
import pkgutil

from openapi_server.apis.ok_api_base import BaseOKApi
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
from openapi_server.models.ok_response import OKResponse
from openapi_server.impl.ok_api_impl import OKApiImpl

impl = OKApiImpl()


router = APIRouter()

ns_pkg = openapi_server.impl
for _, name, _ in pkgutil.iter_modules(ns_pkg.__path__, ns_pkg.__name__ + "."):
    importlib.import_module(name)


@router.get(
    "/ok",
    responses={
        200: {"model": OKResponse, "description": "API is running"},
    },
    tags=["OK"],
    summary="Check API status",
    response_model_by_alias=True,
)
async def ok_get(
) -> OKResponse:
    return impl.ok_get()
