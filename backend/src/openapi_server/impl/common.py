import os
from PIL import Image
from io import BytesIO
from openapi_server.object_storage.minio import minio_client


def read_image_file(file_path: str) -> bytes:
    return minio_client.download_file(file_path)

def write_image_file(filename: str, image_bytes: bytes, quality: int) -> str:
    # 画像圧縮のためにJPEG形式に変換
    if not filename.endswith('.jpeg'):
        filename = os.path.splitext(filename)[0] + '.jpeg'

    image = Image.open(BytesIO(image_bytes))
    image_rgb = image.convert('RGB') # JPEG形式に変換するためにRGB形式に変換
    image_buffer = BytesIO() # 圧縮した画像を保存するためのバッファ
    image_rgb.save(image_buffer, format='JPEG', quality=quality) # 画像をJPEG形式で圧縮
    image_buffer.seek(0) # BytesIOオブジェクトの読み書き位置を先頭に戻す
    minio_client.upload_file(image_buffer, filename)

    return filename
