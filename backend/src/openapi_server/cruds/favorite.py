from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.engine import Result
from sqlalchemy import func

import openapi_server.db_model.tables as db_model


async def get_favorite(db: AsyncSession, furniture_id: int, user_id: int) -> db_model.Favorites:
    result: Result = await db.execute(
        select(db_model.Favorites).where(db_model.Favorites.furniture_id == furniture_id, db_model.Favorites.user_id == user_id)
    )
    favorite: db_model.Favorites = result.first()
    return favorite


async def get_is_favorite(db: AsyncSession, furniture_id: int, user_id: int) -> bool:
    favorite = await get_favorite(db, furniture_id, user_id)
    return True if favorite else False


async def delete_favorite(db: AsyncSession, furniture_id: int, user_id: int) -> bool:
    result: Result = await db.execute(
        select(db_model.Favorites).where(db_model.Favorites.furniture_id == furniture_id, db_model.Favorites.user_id == user_id)
    )
    favorite = result.scalar_one_or_none()
    if favorite is None:
        return False

    await db.delete(favorite)
    await db.commit()

    return True


async def count_favorite_by_furniture_id(db: AsyncSession, furniture_id: int) -> int:
    result = await db.execute(
        select(func.count(db_model.Favorites.favorite_id)).where(db_model.Favorites.furniture_id == furniture_id)
    )
    favorites_count = result.scalar_one_or_none() # SQLのfunc.count() はNoneではなく0を返す
    return favorites_count


async def create_favorite(db: AsyncSession, furniture_id: int, user_id: int) -> bool:
    # 既にいいねされている場合は何もしない
    is_favorite = await get_is_favorite(db, furniture_id, user_id)
    if is_favorite:
        return False

    favorite = db_model.Favorites(furniture_id=furniture_id, user_id=user_id)
    db.add(favorite)
    await db.commit()
    return True
