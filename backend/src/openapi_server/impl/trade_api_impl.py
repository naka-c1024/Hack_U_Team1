import base64
from fastapi import HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from openapi_server.apis.trade_api_base import BaseTradeApi
from openapi_server.models.update_is_checked_request import UpdateIsCheckedRequest
from openapi_server.models.update_trade_request import UpdateTradeRequest
from openapi_server.models.request_trade_request import RequestTradeRequest
from openapi_server.models.trade_list_response import TradeListResponse
from openapi_server.models.trade_response import TradeResponse

import openapi_server.cruds.trade as trade_crud
from openapi_server.impl.common import read_image_file


class TradeApiImpl(BaseTradeApi):
    async def trades_post(self, request_trade_request: RequestTradeRequest, db: AsyncSession) -> None:
        await trade_crud.create_trade(db, request_trade_request)
        return None

    async def trades_get(self, user_id: int, db: AsyncSession) -> TradeListResponse:
        trades = await trade_crud.get_trade(db, user_id=user_id)
        if not trades:
            raise HTTPException(status_code=404, detail="Trade not found")
        
        return TradeListResponse(trades=[
            TradeResponse(
                trade_id            = trade.Trades.trade_id,
                image               = await self._convert_img_data(trade.Furniture.image),
                receiver_name       = trade.Users.username,
                product_name        = trade.Furniture.product_name,
                trade_place         = trade.Furniture.trade_place,
                furniture_id        = trade.Furniture.user_id,
                giver_id            = trade.Furniture.user_id,
                receiver_id         = trade.Trades.receiver_id,
                is_checked          = trade.Trades.is_checked,
                giver_approval      = trade.Trades.giver_approval,
                receiver_approval   = trade.Trades.receiver_approval,
                trade_date_time          = trade.Trades.trade_date_time,
            )
            for trade in trades
        ])

    async def trades_trade_id_get(self, trade_id: int, db: AsyncSession) -> TradeResponse:
        trades = await trade_crud.get_trade(db, trade_id=trade_id)
        if not trades:
            raise HTTPException(status_code=404, detail="Trade not found")
        
        return TradeResponse(
            trade_id            = trades[0].Trades.trade_id,
            image               = await self._convert_img_data(trades[0].Furniture.image),
            receiver_name       = trades[0].Users.username,
            product_name        = trades[0].Furniture.product_name,
            trade_place         = trades[0].Furniture.trade_place,
            furniture_id        = trades[0].Furniture.user_id,
            giver_id            = trades[0].Furniture.user_id,
            receiver_id         = trades[0].Trades.receiver_id,
            is_checked          = trades[0].Trades.is_checked,
            giver_approval      = trades[0].Trades.giver_approval,
            receiver_approval   = trades[0].Trades.receiver_approval,
            trade_date_time          = trades[0].Trades.trade_date_time,
        )

    async def trades_trade_id_is_checked_put(self, trade_id: int, update_is_checked_request: UpdateIsCheckedRequest, db: AsyncSession) -> None:
        trade = await trade_crud.update_is_checked(db, trade_id, update_is_checked_request)
        if not trade:
            raise HTTPException(status_code=404, detail="Trade not found")
        return None

    async def trades_trade_id_put(self, trade_id: int, update_trade_request: UpdateTradeRequest, db: AsyncSession) -> TradeResponse:
        trade = await trade_crud.update_trade(db, trade_id, update_trade_request)
        if not trade:
            raise HTTPException(status_code=404, detail="Trade not found")
        return None
    
    async def _convert_img_data(self, image_file_path: str) -> str:
        try:
            image_bytes = read_image_file(image_file_path)
        except FileNotFoundError:
            raise HTTPException(status_code=404, detail="Image file not found")
        try:
            image_str = base64.b64encode(image_bytes).decode('utf-8')
            return image_str
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Failed to encode or decode image data: {e}")
