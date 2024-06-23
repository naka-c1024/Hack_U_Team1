import os
import aiofiles


async def read_image_file(file_path: str) -> bytes:
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")
    async with aiofiles.open(file_path, 'rb') as file:
        return await file.read()

async def write_image_file(file_path: str, image_bytes: bytes) -> None:
    async with aiofiles.open(file_path, 'wb') as file:
        await file.write(image_bytes)
