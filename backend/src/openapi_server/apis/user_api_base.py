# coding: utf-8

from typing import ClassVar, Dict, List, Tuple  # noqa: F401

from openapi_server.models.login_request import LoginRequest
from openapi_server.models.login_response import LoginResponse
from openapi_server.models.sign_up_request import SignUpRequest


class BaseUserApi:
    subclasses: ClassVar[Tuple] = ()

    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        BaseUserApi.subclasses = BaseUserApi.subclasses + (cls,)
    def login_post(
        self,
        login_request: LoginRequest,
    ) -> LoginResponse:
        ...


    def logout_post(
        self,
    ) -> None:
        ...


    def sign_up_post(
        self,
        sign_up_request: SignUpRequest,
    ) -> None:
        ...
