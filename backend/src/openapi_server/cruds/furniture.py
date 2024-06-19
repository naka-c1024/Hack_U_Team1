from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.engine import Result

from typing import List, Tuple, Optional

import openapi_server.db_model.tables as db_model
from openapi_server.models.register_furniture_request import RegisterFurnitureRequest
from openapi_server.models.furniture_response import FurnitureResponse
from openapi_server.models.furniture_list_response import FurnitureListResponse
from openapi_server.models.furniture_list_request import FurnitureListRequest

from openapi_server.cruds.favorite import get_is_favorite

async def create_furniture(db: AsyncSession, furniture_data: RegisterFurnitureRequest) -> FurnitureResponse:
    new_furniture = db_model.Furniture(
        user_id=furniture_data.user_id,
        product_name=furniture_data.product_name,
        image=furniture_data.image,
        description=furniture_data.description,
        height=furniture_data.height,
        width=furniture_data.width,
        depth=furniture_data.depth,
        category=furniture_data.category,
        color=furniture_data.color,
        start_date=furniture_data.start_date,
        end_date=furniture_data.end_date,
        trade_place=furniture_data.trade_place,
        condition=furniture_data.condition,
    )
    db.add(new_furniture)
    await db.commit()
    await db.refresh(new_furniture)
    return FurnitureResponse(
        furniture_id=new_furniture.furniture_id,
        user_id=new_furniture.user_id,
        product_name=new_furniture.product_name,
        image=new_furniture.image,
        description=new_furniture.description,
        height=new_furniture.height,
        width=new_furniture.width,
        depth=new_furniture.depth,
        category=new_furniture.category,
        color=new_furniture.color,
        start_date=new_furniture.start_date,
        end_date=new_furniture.end_date,
        trade_place=new_furniture.trade_place,
        condition=new_furniture.condition,
        is_sold=new_furniture.is_sold
    )

async def get_furniture(db: AsyncSession, furniture_id: int) -> Optional[FurnitureResponse]:
    result: Result = await db.execute(
        select(db_model.Furniture).where(db_model.Furniture.furniture_id == furniture_id)
    )
    furniture: Optional[Tuple[db_model.Furniture]] = result.first()
    if furniture is None:
        return None
    else:
        furniture = furniture[0]
    
    # # TODO: furniture.user_idからusernameとareaを取得, これはshimadaさんの実装が必要そう
    # user = await get_user(db, furniture.user_id)
    # if user is None:
    #     return None
    
    # furniture.furniture_idとis_favoriteを取得
    is_favorite = await get_is_favorite(db, furniture_id, furniture.user_id)
    
    return FurnitureResponse(
        furniture_id=furniture.furniture_id,
        image=furniture.image,  # 画像データではなくURIであることに注意
        area=1,  # TODO: user.areaを取得
        username="username",  # TODO: user.usernameを取得
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

async def get_furniture_list(db: AsyncSession, request: FurnitureListRequest) -> FurnitureListResponse:
    query = select(db_model.Furniture).where(db_model.Furniture.user_id == request.user_id)
    if request.keyword:
        keyword = f"%{request.keyword}%"
        query = query.where(db_model.Furniture.product_name.like(keyword) | db_model.Furniture.description.like(keyword))
    result = await db.execute(query)
    furniture_list = result.scalars().all()
    return FurnitureListResponse(
        furniture=[FurnitureResponse(
            furniture_id=furniture.furniture_id,
            user_id=furniture.user_id,
            product_name=furniture.product_name,
            image=furniture.image,
            description=furniture.description,
            height=furniture.height,
            width=furniture.width,
            depth=furniture.depth,
            category=furniture.category,
            color=furniture.color,
            start_date=furniture.start_date,
            end_date=furniture.end_date,
            trade_place=furniture.trade_place,
            condition=furniture.condition,
            is_sold=furniture.is_sold
        ) for furniture in furniture_list]
    )

async def delete_furniture(db: AsyncSession, furniture_id: int) -> None:
    result = await db.execute(select(db_model.Furniture).where(db_model.Furniture.furniture_id == furniture_id))
    furniture = result.first()
    if furniture is None:
        return None
    await db.delete(furniture)
    await db.commit()
    return
