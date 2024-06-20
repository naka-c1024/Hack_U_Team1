import aiofiles
import os
import base64
import uuid
import imghdr

from openapi_server.apis.furniture_api_base import BaseFurnitureApi

from openapi_server.models.furniture_list_response import FurnitureListResponse
from openapi_server.models.furniture_list_request import FurnitureListRequest
from openapi_server.models.furniture_response import FurnitureResponse
from openapi_server.models.register_furniture_request import RegisterFurnitureRequest

import openapi_server.cruds.furniture as furniture_crud

from fastapi import HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from typing import Optional


class FurnitureApiImpl(BaseFurnitureApi):
    async def furniture_furniture_id_delete(
        self,
        furniture_id: int,
        db: AsyncSession,
    ) -> None:
        error_msg = await furniture_crud.delete_furniture(db, furniture_id)
        if error_msg is not None:
            raise HTTPException(status_code=400, detail=error_msg)


    async def furniture_furniture_id_get(
        self,
        furniture_id: int,
        user_id: int,
        db: AsyncSession,
    ) -> FurnitureResponse:
        furniture: FurnitureResponse = await furniture_crud.get_furniture(db, furniture_id, user_id)
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
        db: AsyncSession,
    ) -> FurnitureListResponse:
        user_id = furniture_list_request.user_id
        keyword: Optional[str] = furniture_list_request.keyword
        furniture_list: FurnitureListResponse = await furniture_crud.get_furniture_list(db, user_id, keyword)

        if furniture_list is None:
            raise HTTPException(status_code=404, detail="Furniture not found")
        
        # furniture.imageのURIから画像を取得し入れ替える
        for furniture in furniture_list.furniture:
            try:
                image_bytes = await read_image_file(furniture.image)
                image_base64 = base64.b64encode(image_bytes).decode('utf-8')
                furniture.image = image_base64
            except FileNotFoundError:
                raise HTTPException(status_code=404, detail="Image file not found")

        return furniture_list


    async def furniture_post(
        self,
        register_furniture_request: RegisterFurnitureRequest,
        db: AsyncSession,
    ) -> FurnitureResponse:
        SAVE_DIR = "/app/src/openapi_server/file_storage"
        # ディレクトリが存在しない場合はクラッシュさせてよし
        if not os.path.exists(SAVE_DIR):
            raise FileNotFoundError(f"Directory not found: {SAVE_DIR}")
        
        image_bytes = register_furniture_request.image
        image_bytes_base64 = base64.b64decode(image_bytes)
        
        # 画像の拡張子を推定, jpgが推定されない可能性がある(https://x.gd/j4Gi9)
        extension = imghdr.what(None, h=image_bytes_base64)
        if extension is None:
            raise HTTPException(status_code=400, detail="Unsupported image format")

        image_filename = f"{register_furniture_request.user_id}-{register_furniture_request.product_name}-{uuid.uuid4().hex}.{extension}"
        image_path = os.path.join(SAVE_DIR, image_filename)
        await write_image_file(image_path, image_bytes_base64)
        register_furniture_request.image = image_path
        
        furniture: FurnitureResponse = await furniture_crud.create_furniture(db, register_furniture_request)
        if furniture is None:
            raise HTTPException(status_code=400, detail="Failed to create furniture")

        # furniture.imageをURIから画像に入れ替える
        furniture.image = image_bytes
        
        return furniture


async def read_image_file(file_path: str) -> bytes:
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")

    async with aiofiles.open(file_path, 'rb') as file:
        return await file.read()

async def write_image_file(file_path: str, image_bytes: bytes) -> None:
    async with aiofiles.open(file_path, 'wb') as file:
        await file.write(image_bytes)