import json
import base64
from pathlib import Path
from fastapi import UploadFile

# OpenAI APIキーをロード
def load_api_key():
    file_path = Path(__file__).parent / 'secret.json'
    with open(file_path, 'r') as file:
        secrets = json.load(file)
    return secrets['OPENAI_API_KEY']

# 製品情報データをロード
def load_product_data():
    file_path = Path(__file__).parent / 'product_data.json'
    with open(file_path, 'r') as file:
        product_data = json.load(file)
    return product_data

# 画像をBase64でエンコード
async def encode_image_to_base64(image: UploadFile):
    image_data = await image.read()
    return base64.b64encode(image_data).decode('utf-8')

# 製品情報データから色のインデックスを取得
def select_color_index(color: str):
    color_list = load_product_data()['colors']
    for i, c in enumerate(color_list):
        if color in c or c in color:
            return i
    raise -1

# 製品情報データからカテゴリのインデックスを取得
def select_category_index(category: str):
    category_list = load_product_data()['categories']
    for i, c in enumerate(category_list):
        if category in c or c in category:
            return i
    raise -1
