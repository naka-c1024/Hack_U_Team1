from openapi_server.apis.favorite_api_base import BaseFavoriteApi
from openapi_server.models.favorite_response import FavoriteResponse
import openapi_server.cruds.favorite as favorite_crud

from sqlalchemy.ext.asyncio import AsyncSession


class FavoriteApiImpl(BaseFavoriteApi):
    async def favorite_delete(
        self,
        furniture_id: int,
        user_id: int,
        db: AsyncSession,
    ) -> None:
        return await favorite_crud.delete_favorite(db, furniture_id, user_id)


    async def favorite_furniture_id_get(
        self,
        furniture_id: int,
        db: AsyncSession,
    ) -> FavoriteResponse:
        favorites_count: int = await favorite_crud.get_favorite_count_by_furniture_id(db, furniture_id)
        return FavoriteResponse(count_favorites=favorites_count)


    async def favorite_post(
        self,
        furniture_id: int,
        user_id: int,
        db: AsyncSession,
    ) -> None:
        return await favorite_crud.create_favorite(db, furniture_id, user_id)
