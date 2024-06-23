from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.engine import Result
from sqlalchemy.sql import or_

from typing import List, Tuple, Optional
from datetime import datetime

import openapi_server.db_model.tables as db_model
from openapi_server.models.furniture_response import FurnitureResponse
from openapi_server.models.furniture_list_response import FurnitureListResponse

from openapi_server.cruds.favorite import get_is_favorite
from openapi_server.cruds.user_api import get_user

async def delete_furniture(db: AsyncSession, furniture_id: int) -> Tuple[Optional[str], Optional[str]]:
    result: Result = await db.execute(
        select(db_model.Furniture).where(db_model.Furniture.furniture_id == furniture_id)
    )
    furniture = result.scalar_one_or_none()
    if furniture is None:
        return None, "Furniture not found"

    # 取引履歴がある場合は削除不可
    result: Result = await db.execute(
        select(db_model.Trades).where(db_model.Trades.furniture_id == furniture_id)
    )
    if result.first():
        return None, "Furniture has trade history and cannot be deleted"

    # 画像ファイル削除するためにファイルパスを取得
    image_filepath = furniture.image
    await db.delete(furniture)
    await db.commit()
    return image_filepath, None

async def get_furniture(db: AsyncSession, furniture_id: int, request_user_id: int) -> Optional[FurnitureResponse]:
    result: Result = await db.execute(
        select(db_model.Furniture).where(db_model.Furniture.furniture_id == furniture_id)
    )
    furniture = result.scalar_one_or_none()
    if furniture is None:
        return None

    user = await get_user(db, furniture.user_id)
    if user is None:
        return None
    is_favorite = await get_is_favorite(db, furniture_id, request_user_id)
    return await build_furniture_response(furniture, user, is_favorite)

async def get_furniture_list(db: AsyncSession, request_user_id: int, category: Optional[int], keyword: Optional[str]) -> FurnitureListResponse:
    query = select(db_model.Furniture)
    if category is not None:
        query = query.where(db_model.Furniture.category == category)
    if keyword:
        keyword_conditions = []
        for word in keyword.split():
            keyword_conditions.append(db_model.Furniture.product_name.like(f'%{word}%'))
            keyword_conditions.append(db_model.Furniture.description.like(f'%{word}%'))
        query = query.where(or_(*keyword_conditions))

    result: Result = await db.execute(query)
    furniture_list = result.scalars().all()
    if not furniture_list:
        return FurnitureListResponse(furniture=[])

    response_list = []
    for furniture in furniture_list:
        user = await get_user(db, furniture.user_id)
        if user is None:
            continue
        is_favorite = await get_is_favorite(db, furniture.furniture_id, request_user_id)
        response_list.append(await build_furniture_response(furniture, user, is_favorite))

    return FurnitureListResponse(furniture=response_list)

async def create_furniture(
        db: AsyncSession,
        user_id: int,
        product_name: str,
        image_path: str,
        description: str,
        height: float,
        width: float,
        depth: float,
        category: int,
        color: int,
        condition: int,
        trade_place: str,
        start_date: Optional[str] = None,
        end_date: Optional[str] = None,
    ) -> Optional[FurnitureResponse]:
    start_date_parsed = datetime.strptime(start_date, "%Y-%m-%d").date() if start_date else None
    end_date_parsed = datetime.strptime(end_date, "%Y-%m-%d").date() if end_date else None
    furniture = db_model.Furniture(
        user_id=user_id,
        product_name=product_name,
        image=image_path,
        description=description,
        height=height,
        width=width,
        depth=depth,
        category=category,
        color=color,
        condition=condition,
        start_date=start_date_parsed,
        end_date=end_date_parsed,
        trade_place=trade_place,
    )
    db.add(furniture)
    await db.commit()
    await db.refresh(furniture)
    user = await get_user(db, furniture.user_id)
    if user is None:
        return None
    return await build_furniture_response(furniture, user)

async def build_furniture_response(furniture: db_model.Furniture, user: db_model.Users, is_favorite: Optional[bool] = False) -> FurnitureResponse:
    return FurnitureResponse(
        furniture_id=furniture.furniture_id,
        image=furniture.image,
        area=user.area,
        username=user.username,
        product_name=furniture.product_name,
        description=furniture.description,
        size=f"{furniture.height} {furniture.width} {furniture.depth}",
        category=furniture.category,
        color=furniture.color,
        condition=furniture.condition,
        is_sold=furniture.is_sold,
        start_date=furniture.start_date,
        end_date=furniture.end_date,
        trade_place=furniture.trade_place,
        is_favorite=is_favorite,
    )
