from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.engine import Result

import openapi_server.db_model.tables as db_model

async def get_is_favorite(db: AsyncSession, user_id: int, furniture_id: int) -> bool:
    result: Result = await db.execute(
        select(db_model.Favorites).where(db_model.Favorites.user_id == user_id, db_model.Favorites.furniture_id == furniture_id)
    )
    favorite: db_model.Favorites = result.first()
    return True if favorite else False

async def create_favorite(db: AsyncSession, furniture_id: int, user_id: int) -> None:
    is_favorite = await get_is_favorite(db, user_id, furniture_id)
    if is_favorite:
        return

    favorite = db_model.Favorites(furniture_id=furniture_id, user_id=user_id)
    db.add(favorite)
    await db.commit()
