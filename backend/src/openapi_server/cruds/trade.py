from  sqlalchemy.ext.asyncio import AsyncSession

import openapi_server.db_model.tables as db_model

from openapi_server.models.request_trade_request import RequestTradeRequest

async def create_trade(
    db: AsyncSession,
    request_trade_request: RequestTradeRequest
):
    print(request_trade_request.dict())
    trade = db_model.Trades(**request_trade_request.dict())
    db.add(trade)
    await db.commit()
    await db.refresh(trade)