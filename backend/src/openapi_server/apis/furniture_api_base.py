# coding: utf-8

from typing import ClassVar, Dict, List, Tuple  # noqa: F401

from openapi_server.models.furniture_list_response import FurnitureListResponse
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
    ) -> FurnitureResponse:
        ...


    def furniture_get(
        self,
        user_id: int,
    ) -> FurnitureListResponse:
        ...


    def furniture_post(
        self,
        user_id: int,
        register_furniture_request: RegisterFurnitureRequest,
    ) -> FurnitureResponse:
        ...