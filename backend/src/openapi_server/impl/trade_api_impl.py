from openapi_server.models.update_is_checked_request import UpdateIsCheckedRequest
from openapi_server.apis.trade_api_base import BaseTradeApi

from openapi_server.models.update_trade_request import UpdateTradeRequest
from openapi_server.models.request_trade_request import RequestTradeRequest
from openapi_server.models.trade_list_response import TradeListResponse
from openapi_server.models.trade_response import TradeResponse

import openapi_server.cruds.trade as trade_crud

from sqlalchemy.ext.asyncio import AsyncSession

class TradeApiImpl(BaseTradeApi):
    async def trades_get(self, user_id: int, db: AsyncSession) -> TradeListResponse:
        return TradeListResponse()

    async def trades_post(self, request_trade_request: RequestTradeRequest, db: AsyncSession) -> None:
        return None

    async def trades_trade_id_get(self, trade_id: int, db: AsyncSession) -> TradeResponse:
        return TradeResponse()

    async def trades_trade_id_is_checked_put(self, trade_id: int, update_is_checked_request: UpdateIsCheckedRequest, db: AsyncSession) -> None:
        return None

    async def trades_trade_id_put(self, trade_id: int, update_trade_request: UpdateTradeRequest, db: AsyncSession) -> TradeResponse:
        return None