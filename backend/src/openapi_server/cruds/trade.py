from  sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.engine import Result

from openapi_server.db_model.tables import Trades, Furniture, Users

from openapi_server.models.request_trade_request import RequestTradeRequest

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
    return trade

async def get_trade(
    db: AsyncSession,
    user_id: Optional[int] = None,
    trade_id: Optional[int] = None
):
    query = select(Trades, Furniture, Users)
    query = query.join(Furniture, Trades.furniture_id == Furniture.furniture_id)
    query = query.join(Users, Furniture.user_id == Users.user_id)
    if user_id:
        query = query.where((Trades.receiver_id == user_id) | (Furniture.user_id == user_id))
    if trade_id:
        query = query.where(Trades.trade_id == trade_id)

    result: Result = await db.execute(query)
    return result.all()

async def update_is_checked(
    db: AsyncSession,
    trade_id: int,
    update_is_checked_request
):
    result = (await db.execute(select(Trades).where(Trades.trade_id == trade_id))).all()
    if not result:
        return None
    trade = result[0].Trades
    trade.is_checked = update_is_checked_request.is_checked
    db.add(trade)
    await db.commit()
    await db.refresh(trade)
    return trade

async def update_trade(
    db: AsyncSession,
    trade_id: int,
    update_trade_request: RequestTradeRequest
):
    result = (await db.execute(select(Trades).where(Trades.trade_id == trade_id))).all()
    if not result:
        return None
    trade = result[0].Trades
    result = (await db.execute(select(Furniture).where(Furniture.furniture_id == trade.furniture_id))).all()
    if not result:
        return None
    furniture = result[0].Furniture

    # 承認フラグを立てる
    if update_trade_request.is_giver:
        trade.giver_approval = True
    else:
        trade.receiver_approval = True
    
    # 双方が承認したら取引成立
    if trade.giver_approval and trade.receiver_approval:
        furniture.is_sold = True
    
    db.add(trade)
    db.add(furniture)
    await db.commit()
    await db.refresh(trade)
    await db.refresh(furniture)
    return trade