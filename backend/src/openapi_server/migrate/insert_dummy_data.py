import os
import requests
from PIL import Image
from io import BytesIO
from urllib.parse import urlparse, unquote
import yaml
from urllib.parse import urlparse, unquote
from sqlalchemy.orm import Session
from openapi_server.db_model.tables import Users, Furniture, Trades, Favorites, Chats

def insert_dummy_data(session: Session):
    yaml_file_path = "/app/src/openapi_server/migrate/dummy_data.yaml"
    with open(yaml_file_path, 'r', encoding='utf-8') as file:
        data = yaml.safe_load(file)

    # Insert users
    users = [Users(**user_data) for user_data in data['users']]
    session.add_all(users)
    session.flush()  # メモリ消費を抑えるため
    session.flush()  # メモリ消費を抑えるため

    # Insert furniture
    SAVE_DIR = "/app/src/openapi_server/file_storage"
    QUALITY = 40 # 画像の圧縮率, 低いほど圧縮されるが画質が劣化する
    for item in data['furniture']:
        image_url = item.pop('image_url')
        file_path = download_and_compress_image(image_url, SAVE_DIR, QUALITY)
        item['image'] = os.path.join(SAVE_DIR, file_path)
        session.add(Furniture(**item))
    session.flush()  # メモリ消費を抑えるため
    session.flush()  # メモリ消費を抑えるため

    # Insert trades
    trades = [Trades(**trade_data) for trade_data in data['trades']]
    session.add_all(trades)

    # Insert favorites
    favorites = [Favorites(**favorite_data) for favorite_data in data['favorites']]
    session.add_all(favorites)

    # insert chats
    chats = [Chats(**chat_data) for chat_data in data['chats']]
    session.add_all(chats)

    session.commit()

def download_and_compress_image(url, save_dir, quality) -> str:
    if not os.path.exists(save_dir):
        raise FileNotFoundError(f"Directory not found: {save_dir}")

    parsed_url = urlparse(url)
    filename = os.path.basename(parsed_url.path)
    filename = unquote(filename)  # クエリパラメータを削除

    # 画像を取得
    response = requests.get(url)
    # リクエストが成功したか確認
    response.raise_for_status()

    # 画像をJPEG形式で圧縮
    image = Image.open(BytesIO(response.content))
    filename = os.path.splitext(filename)[0] + '.jpeg'  # 拡張子を.jpegに変更
    file_path = os.path.join(save_dir, filename)
    image.save(file_path, 'JPEG', quality=quality)  # JPEG形式で保存、品質はパラメータで調整

    return file_path
