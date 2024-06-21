# coding: utf-8

from typing import ClassVar, Dict, List, Tuple  # noqa: F401

from openapi_server.models.error_response import ErrorResponse
from openapi_server.models.furniture_describe_response import FurnitureDescribeResponse
from openapi_server.models.furniture_list_request import FurnitureListRequest
from openapi_server.models.furniture_list_response import FurnitureListResponse
from openapi_server.models.furniture_request import FurnitureRequest
from openapi_server.models.furniture_response import FurnitureResponse

from fastapi import UploadFile


class BaseFurnitureApi:
    subclasses: ClassVar[Tuple] = ()

    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        BaseFurnitureApi.subclasses = BaseFurnitureApi.subclasses + (cls,)
    def furniture_describe_post(
        self,
        image: UploadFile,
    ) -> FurnitureDescribeResponse:
        ...


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
        user_id: int,
        product_name: str,
        image: UploadFile,
        description: str,
        height: float,
        width: float,
        depth: float,
        category: int,
        color: int,
        start_date: str,
        end_date: str,
        trade_place: str,
        condition: int,
    ) -> FurnitureResponse:
        ...


    def furniture_recommend_post(
        self,
        room_photo: UploadFile,
        category: int,
    ) -> FurnitureListResponse:
        ...
