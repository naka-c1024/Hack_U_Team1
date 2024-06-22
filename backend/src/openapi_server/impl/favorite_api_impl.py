from openapi_server.apis.favorite_api_base import BaseFavoriteApi
from openapi_server.models.favorite_response import FavoriteResponse
import openapi_server.cruds.favorite as favorite_crud

from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import HTTPException, status


class FavoriteApiImpl(BaseFavoriteApi):
    async def favorite_delete(
        self,
        furniture_id: int,
        user_id: int,
        db: AsyncSession,
    ) -> None:
        is_deleted = await favorite_crud.delete_favorite(db, furniture_id, user_id)
        if not is_deleted:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Favorite not found")


    async def favorite_furniture_id_get(
        self,
        furniture_id: int,
        db: AsyncSession,
    ) -> FavoriteResponse:
        favorites_count = await favorite_crud.count_favorite_by_furniture_id(db, furniture_id)
        return FavoriteResponse(favorites_count=favorites_count)


    async def favorite_post(
        self,
        furniture_id: int,
        user_id: int,
        db: AsyncSession,
    ) -> None:
        is_created = await favorite_crud.create_favorite(db, furniture_id, user_id)
        if not is_created:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Favorite already exists")
