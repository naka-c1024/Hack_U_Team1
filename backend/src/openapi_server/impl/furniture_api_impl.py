import aiofiles
import os
import base64
import uuid

from openapi_server.apis.furniture_api_base import BaseFurnitureApi
from openapi_server.models.furniture_list_response import FurnitureListResponse
from openapi_server.models.furniture_response import FurnitureResponse
from openapi_server.models.furniture_describe_response import FurnitureDescribeResponse

import openapi_server.cruds.furniture as furniture_crud

from fastapi import HTTPException, UploadFile
from sqlalchemy.ext.asyncio import AsyncSession
from typing import Optional, List

class FurnitureApiImpl(BaseFurnitureApi):
    async def furniture_describe_post(
        self,
        image: UploadFile,
    ) -> FurnitureDescribeResponse:
        # TODO: describe_furniture_from_imageの実装
        # return await describe_furniture_from_image(image)
        return FurnitureDescribeResponse( # ダミー
            product_name="product_name",
            description="description",
            category=1,
            color=1,
        )

    async def furniture_furniture_id_delete(
        self,
        furniture_id: int,
        db: AsyncSession,
    ) -> None:
        image_uri, err_msg = await furniture_crud.delete_furniture(db, furniture_id)
        if err_msg:
            if err_msg == "Furniture not found":
                raise HTTPException(status_code=404, detail=err_msg)
            else:
                raise HTTPException(status_code=400, detail=err_msg)
        elif image_uri and os.path.exists(image_uri):
            os.remove(image_uri)

    async def furniture_furniture_id_get(
        self,
        furniture_id: int,
        request_user_id: int,
        db: AsyncSession,
    ) -> FurnitureResponse:
        furniture = await furniture_crud.get_furniture(db, furniture_id, request_user_id)
        if furniture is None:
            raise HTTPException(status_code=404, detail="Furniture not found")
        await self._embed_image_data(furniture)
        return furniture

    async def furniture_get(
        self,
        request_user_id: int,
        keyword: Optional[str],
        db: AsyncSession,
    ) -> FurnitureListResponse:
        furniture_list = await furniture_crud.get_furniture_list(db, request_user_id, keyword)
        if not furniture_list.furniture:
            raise HTTPException(status_code=404, detail="Furniture not found")
        await self._embed_image_data_list(furniture_list.furniture)
        return furniture_list

    async def furniture_post(
        self,
        user_id: int,
        product_name: str,
        image: UploadFile,
        description: str,
        height: float,
        width: float,
        depth: float,
        category: int,
        color: int,
        start_date: str,
        end_date: str,
        trade_place: str,
        condition: int,
        db: AsyncSession,
    ) -> FurnitureResponse:
        image_path = await self._save_image(user_id, product_name, image)
        furniture = await furniture_crud.create_furniture(
            db,
            user_id,
            product_name,
            image_path,
            description,
            height,
            width,
            depth,
            category,
            color,
            condition,
            trade_place,
            start_date,
            end_date,
        )
        if furniture is None:
            raise HTTPException(status_code=400, detail="Failed to create furniture")
        await self._embed_image_data(furniture, image_path)
        return furniture

    async def furniture_recommend_post(
        self,
        room_photo: UploadFile,
        category: int,
    ) -> FurnitureListResponse:
        # まずカテゴリで絞る?それとも先にAIを使ってその結果を元にkeywordなども含めて絞る?
        # アルゴリズムが決まったらそれに伴うDB処理を実装します！
        # TODO: recommend_furniture_from_imageの実装
        # response = await recommend_furniture_from_image(room_photo, category)
        return FurnitureListResponse() # ダミー

    async def _save_image(self, user_id: int, product_name: str, image: UploadFile) -> str:
        SAVE_DIR = "/app/src/openapi_server/file_storage"
        if not os.path.exists(SAVE_DIR):
            # ディレクトリが未作成の場合はInternalServerErrorにしてよし
            raise FileNotFoundError(f"Directory not found: {SAVE_DIR}")
        extension = image.filename.split('.')[-1]
        image_filename = f"userid{user_id}-{product_name}-{uuid.uuid4().hex}.{extension}"
        image_path = os.path.join(SAVE_DIR, image_filename)
        image_bytes = await image.read()
        await write_image_file(image_path, image_bytes)
        return image_path

    async def _embed_image_data(self, furniture: FurnitureResponse, image_path: Optional[str] = None):
        try:
            if image_path:
                image_bytes = await read_image_file(image_path)
            else:
                image_bytes = await read_image_file(furniture.image)
            try:
                furniture.image = base64.b64encode(image_bytes).decode('utf-8')
            except Exception as e:
                # bytesがbase64に変換できない場合にエラーを返す
                raise HTTPException(status_code=500, detail="Failed to encode or decode image data")
        except FileNotFoundError:
            raise HTTPException(status_code=404, detail="Image file not found")

    async def _embed_image_data_list(self, furniture_list: List[FurnitureResponse]):
        for furniture in furniture_list:
            await self._embed_image_data(furniture)

async def read_image_file(file_path: str) -> bytes:
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")
    async with aiofiles.open(file_path, 'rb') as file:
        return await file.read()

async def write_image_file(file_path: str, image_bytes: bytes) -> None:
    async with aiofiles.open(file_path, 'wb') as file:
        await file.write(image_bytes)
