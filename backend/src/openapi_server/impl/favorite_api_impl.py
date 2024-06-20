from openapi_server.apis.favorite_api_base import BaseFavoriteApi
from openapi_server.models.favorite_response import FavoriteResponse
from sqlalchemy.ext.asyncio import AsyncSession
import openapi_server.cruds.favorite as favorite_crud

class FavoriteApiImpl(BaseFavoriteApi):
    async def favorite_delete(
        self,
        furniture_id: int,
        user_id: int,
        db: AsyncSession,
    ) -> None:
        ...


    async def favorite_furniture_id_get(
        self,
        furniture_id: int,
        db: AsyncSession,
    ) -> FavoriteResponse:
        ...


    async def favorite_post(
        self,
        furniture_id: int,
        user_id: int,
        db: AsyncSession,
    ) -> None:
        return await favorite_crud.create_favorite(db, furniture_id, user_id)
