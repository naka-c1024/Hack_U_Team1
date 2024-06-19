# coding: utf-8

from typing import ClassVar, Dict, List, Tuple  # noqa: F401

from openapi_server.models.error_response import ErrorResponse
from openapi_server.models.furniture_list_request import FurnitureListRequest
from openapi_server.models.furniture_list_response import FurnitureListResponse
from openapi_server.models.furniture_request import FurnitureRequest
from openapi_server.models.furniture_response import FurnitureResponse
from openapi_server.models.register_furniture_request import RegisterFurnitureRequest


class BaseFurnitureApi:
    subclasses: ClassVar[Tuple] = ()

    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        BaseFurnitureApi.subclasses = BaseFurnitureApi.subclasses + (cls,)
    def furniture_furniture_id_delete(
        self,
        furniture_id: int,
    ) -> None:
        ...


    def furniture_furniture_id_get(
        self,
        furniture_id: int,
        furniture_request: FurnitureRequest,
    ) -> FurnitureResponse:
        ...


    def furniture_get(
        self,
        furniture_list_request: FurnitureListRequest,
    ) -> FurnitureListResponse:
        ...


    def furniture_post(
        self,
        register_furniture_request: RegisterFurnitureRequest,
    ) -> FurnitureResponse:
        ...
