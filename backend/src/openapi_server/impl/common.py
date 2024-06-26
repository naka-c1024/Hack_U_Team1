import os
import aiofiles
from PIL import Image
from io import BytesIO


async def read_image_file(file_path: str) -> bytes:
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")
    async with aiofiles.open(file_path, 'rb') as file:
        return await file.read()

async def write_image_file(save_dir: str, filename: str, image_bytes: bytes, quality: int) -> str:
    '''
    filename: 保存するファイル名, 拡張子は必ずjpeg
    '''
    file_path = os.path.join(save_dir, filename)

    image = Image.open(BytesIO(image_bytes))
    image_rgb = image.convert('RGB') # JPEG形式に変換するためにRGB形式に変換

    async with aiofiles.open(file_path, 'wb') as file:
        img_byte_arr = BytesIO()
        image_rgb.save(img_byte_arr, format='JPEG', quality=quality)
        await file.write(img_byte_arr.getvalue())

    return file_path
