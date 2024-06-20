from  sqlalchemy.ext.asyncio import AsyncSession

import openapi_server.db_model.tables as db_model

from openapi_server.models.request_trade_request import RequestTradeRequest

async def create_trade(
    db: AsyncSession,
    request_trade_request: RequestTradeRequest
):
    trade_request = {
        "furniture_id"      : request_trade_request.furniture_id,
        "receiver_id"       : request_trade_request.user_id,
        "is_checked"        : False,
        "giver_approval"    : False,
        "receiver_approval" : False,
        "trade_date"        : request_trade_request.trade_date
    }
    trade = db_model.Trades(**trade_request)
    db.add(trade)
    await db.commit()
    await db.refresh(trade)