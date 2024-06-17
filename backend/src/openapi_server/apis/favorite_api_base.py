# coding: utf-8

from typing import ClassVar, Dict, List, Tuple  # noqa: F401

from openapi_server.models.error_response import ErrorResponse
from openapi_server.models.favorite_response import FavoriteResponse


class BaseFavoriteApi:
    subclasses: ClassVar[Tuple] = ()

    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        BaseFavoriteApi.subclasses = BaseFavoriteApi.subclasses + (cls,)
    def favorite_delete(
        self,
        furniture_id: int,
        user_id: int,
    ) -> None:
        ...


    def favorite_furniture_id_get(
        self,
        furniture_id: int,
    ) -> FavoriteResponse:
        ...


    def favorite_post(
        self,
        furniture_id: int,
        user_id: int,
    ) -> None:
        ...
