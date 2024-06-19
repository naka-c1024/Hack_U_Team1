import aiofiles
import os
import base64

from openapi_server.apis.furniture_api_base import BaseFurnitureApi

from openapi_server.models.furniture_list_response import FurnitureListResponse
from openapi_server.models.furniture_list_request import FurnitureListRequest
from openapi_server.models.furniture_response import FurnitureResponse
from openapi_server.models.register_furniture_request import RegisterFurnitureRequest

import openapi_server.cruds.furniture as furniture_crud
from openapi_server.db import get_db

from fastapi import Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession


# class FurnitureApiImpl(BaseFurnitureApi):
class FurnitureApiImpl():
    async def furniture_furniture_id_delete(
        self,
        furniture_id: int,
        db: AsyncSession = Depends(get_db),
    ) -> None:
        # furniture = await furniture_crud.get_furniture(db, furniture_id)
        # if furniture is None:
        #     raise HTTPException(status_code=404, detail="Furniture not found")
        
        # return await furniture_crud.delete_furniture(db, furniture_id=furniture_id)
        ...


    async def furniture_furniture_id_get(
        self,
        furniture_id: int,
        db: AsyncSession,
    ) -> FurnitureResponse:
        
        furniture: FurnitureResponse = await furniture_crud.get_furniture(db, furniture_id)
        if furniture is None:
            raise HTTPException(status_code=404, detail="Furniture not found")
        
        # furniture.imageのURIから画像を取得し入れ替える
        try:
            image_bytes = await read_image_file(furniture.image)
            image_base64 = base64.b64encode(image_bytes).decode('utf-8')
            furniture.image = image_base64
        except FileNotFoundError:
            raise HTTPException(status_code=404, detail="Image file not found")
        
        return furniture


    async def furniture_get(
        self,
        furniture_list_request: FurnitureListRequest,
        db: AsyncSession = Depends(get_db),
    ) -> FurnitureListResponse:
        ...


    async def furniture_post(
        self,
        user_id: int,
        register_furniture_request: RegisterFurnitureRequest,
        db: AsyncSession = Depends(get_db),
    ) -> FurnitureResponse:
        ...


async def read_image_file(file_path: str) -> bytes:
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")

    async with aiofiles.open(file_path, 'rb') as file:
        return await file.read()
