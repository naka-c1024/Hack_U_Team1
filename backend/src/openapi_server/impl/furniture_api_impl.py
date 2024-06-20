import aiofiles
import os
import base64
import uuid

from openapi_server.apis.furniture_api_base import BaseFurnitureApi

from openapi_server.models.furniture_list_response import FurnitureListResponse
from openapi_server.models.furniture_list_request import FurnitureListRequest
from openapi_server.models.furniture_response import FurnitureResponse
from openapi_server.models.furniture_describe_response import FurnitureDescribeResponse

import openapi_server.cruds.furniture as furniture_crud

from fastapi import HTTPException, UploadFile
from sqlalchemy.ext.asyncio import AsyncSession
from typing import Optional


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
        image_uri_or_error_msg = await furniture_crud.delete_furniture(db, furniture_id)
        if os.path.exists(image_uri_or_error_msg):
            # ファイルが存在していたら削除
            os.remove(image_uri_or_error_msg)
        elif image_uri_or_error_msg is not None:
            raise HTTPException(status_code=400, detail=image_uri_or_error_msg)


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
        SAVE_DIR = "/app/src/openapi_server/file_storage"
        # ディレクトリが存在しない場合はクラッシュさせてよし
        if not os.path.exists(SAVE_DIR):
            raise FileNotFoundError(f"Directory not found: {SAVE_DIR}")
        
        extension = image.filename.split('.')[-1]
        image_filename = f"{user_id}-{product_name}-{uuid.uuid4().hex}.{extension}"
        image_path = os.path.join(SAVE_DIR, image_filename)
        image_bytes = await image.read()
        await write_image_file(image_path, image_bytes)
        
        furniture: FurnitureResponse = await furniture_crud.create_furniture(
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

        # DBから渡されたfurniture.imageはURIなので、レスポンスでは画像データに入れ替える
        image_base64 = base64.b64encode(image_bytes).decode('utf-8')
        furniture.image = image_base64
        
        return furniture


async def read_image_file(file_path: str) -> bytes:
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")

    async with aiofiles.open(file_path, 'rb') as file:
        return await file.read()

async def write_image_file(file_path: str, image_bytes: bytes) -> None:
    async with aiofiles.open(file_path, 'wb') as file:
        await file.write(image_bytes)
