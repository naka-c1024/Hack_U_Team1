from  sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.engine import Result

from openapi_server.db_model.tables import Trades, Furniture

from openapi_server.models.request_trade_request import RequestTradeRequest
from openapi_server.models.trade_list_response import TradeListResponse
from openapi_server.models.trade_response import TradeResponse

from openapi_server.cruds.user_api import get_user

from typing import List, Tuple, Optional

async def create_trade(
    db: AsyncSession,
    request_trade_request: RequestTradeRequest
):
    trade = Trades(
        furniture_id        = request_trade_request.furniture_id,
        receiver_id         = request_trade_request.user_id,
        is_checked          = False,
        giver_approval      = False,
        receiver_approval   = False,
        trade_date          = request_trade_request.trade_date
        
    )
    db.add(trade)
    await db.commit()
    await db.refresh(trade)

async def get_trade_list(
    db: AsyncSession,
    user_id: int
) -> TradeListResponse:
    query = select(
        Trades,
        Furniture
    ).join(Furniture, Trades.furniture_id == Furniture.furniture_id).where(
        (Trades.receiver_id == user_id) | (Furniture.user_id == user_id)
    )

    result: Result = await db.execute(query)
    trades = result.all()
    if not trades:
        return None

    trade_list_response = []
    for trade in trades:
        user = await get_user(db, trade.Furniture.user_id)
        trade_list_response.append(
            TradeResponse(
                trade_id            = trade.Trades.trade_id,
                image               = trade.Furniture.image,
                receiver_name       = user.username,
                product_name        = trade.Furniture.product_name,
                trade_place         = trade.Furniture.trade_place,
                furniture_id        = trade.Furniture.user_id,
                giver_id            = trade.Furniture.user_id,
                receiver_id         = trade.Trades.receiver_id,
                is_checked          = trade.Trades.is_checked,
                giver_approval      = trade.Trades.giver_approval,
                receiver_approval   = trade.Trades.receiver_approval,
                trade_date          = trade.Trades.trade_date,
            )
        )
    return TradeListResponse(trades=trade_list_response)

async def get_trade(
    db: AsyncSession,
    trade_id: int
) -> TradeResponse:
    query = select(
        Trades,
        Furniture
    ).join(Furniture, Trades.furniture_id == Furniture.furniture_id).where(
        Trades.trade_id == trade_id
    )

    result: Result = await db.execute(query)
    trade = result.first()
    if not trade:
        return None

    user = await get_user(db, trade.Furniture.user_id)
    return TradeResponse(
        trade_id            = trade.Trades.trade_id,
        image               = trade.Furniture.image,
        receiver_name       = user.username,
        product_name        = trade.Furniture.product_name,
        trade_place         = trade.Furniture.trade_place,
        furniture_id        = trade.Furniture.user_id,
        giver_id            = trade.Furniture.user_id,
        receiver_id         = trade.Trades.receiver_id,
        is_checked          = trade.Trades.is_checked,
        giver_approval      = trade.Trades.giver_approval,
        receiver_approval   = trade.Trades.receiver_approval,
        trade_date          = trade.Trades.trade_date,
    )