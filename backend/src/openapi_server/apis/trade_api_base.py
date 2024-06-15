# coding: utf-8

from typing import ClassVar, Dict, List, Tuple  # noqa: F401

from openapi_server.models.request_trade_request import RequestTradeRequest
from openapi_server.models.trade_list_response import TradeListResponse
from openapi_server.models.update_is_checked_request import UpdateIsCheckedRequest
from openapi_server.models.update_trade_request import UpdateTradeRequest


class BaseTradeApi:
    subclasses: ClassVar[Tuple] = ()

    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        BaseTradeApi.subclasses = BaseTradeApi.subclasses + (cls,)
    def trades_get(
        self,
        user_id: int,
    ) -> TradeListResponse:
        ...


    def trades_post(
        self,
        request_trade_request: RequestTradeRequest,
    ) -> None:
        ...


    def trades_trade_id_is_checked_put(
        self,
        trade_id: int,
        update_is_checked_request: UpdateIsCheckedRequest,
    ) -> None:
        ...


    def trades_trade_id_put(
        self,
        trade_id: int,
        update_trade_request: UpdateTradeRequest,
    ) -> None:
        ...
