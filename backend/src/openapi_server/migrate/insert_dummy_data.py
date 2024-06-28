import os
import requests
import yaml
from sqlalchemy.orm import Session
from urllib.parse import urlparse, unquote

from openapi_server.db_model.tables import Users, Furniture, Trades, Favorites, Chats
from openapi_server.impl.common import write_image_file


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
    QUALITY = 40 # 画像の圧縮率, 低いほど圧縮されるが画質が劣化する
    for item in data['furniture']:
        image_url = item.pop('image_url')
        filename = download_and_compress_image(image_url, QUALITY)
        item['image'] = filename
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


def download_and_compress_image(url, quality) -> str:
    parsed_url = urlparse(url)
    filename = os.path.basename(parsed_url.path)
    filename = unquote(filename)  # クエリパラメータを削除

    # 画像を取得
    response = requests.get(url)
    # リクエストが成功したか確認
    response.raise_for_status()

    # 画像をJPEG形式で圧縮するために拡張子を変更
    filename = 'demo-' + os.path.splitext(filename)[0] + '.jpeg'

    return write_image_file(filename, response.content, quality)
