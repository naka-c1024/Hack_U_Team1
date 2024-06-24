import openai
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

class FurnitureDescribe:
    def __init__(self):
        openai.api_key = load_api_key()
        self.product_data = load_product_data()
    
    async def get_describe(self, image: UploadFile):
        # 画像をBase64エンコード
        base64_image = await encode_image_to_base64(image)
        # OpenAI APIリクエストの実行
        response = openai.ChatCompletion.create(
            model="gpt-4o",
            messages=[
                {
                    "role": "system",
                    "content": "入力された画像に対して家具名, 説明, 色, カテゴリをカンマ区切りで出力してください\n 例: テーブル, 木製のテーブルです, 赤, テーブル"
                },
                {
                    "role": "system",
                    "content": "家具名や説明はフリマアプリに出品する際の説明文を想定してください"
                },
                {
                    "role": "system",
                    "content": "色は以下から選んでください".join(self.product_data['colors'])
                },
                {
                    "role": "system",
                    "content": "カテゴリは以下から選んでください".join(self.product_data['categories'])
                },
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": f"data:image/jpeg;base64,{base64_image}"
                            }
                        }
                    ]
                }
            ],
            max_tokens=300,
        )
        name, description, color, category = response.choices[0].message["content"].split(",")
        color_idx = select_color_index(color)
        category_idx = select_category_index(category)
        return {
            "product_name"  : name, 
            "description"   : description, 
            "color"         : color_idx,
            "category"      : category_idx
        }

class FurnitureRecommendation:
    def __init__(self):
        openai.api_key = load_api_key()
        self.product_data = load_product_data()

    async def get_recommend_color(self, image: UploadFile):
        color_list = self.product_data['colors']

        # 画像をBase64エンコード
        base64_image = await encode_image_to_base64(image)
        # OpenAI APIリクエストの実行
        response = openai.ChatCompletion.create(
            model="gpt-4o",
            messages=[
                {
                    "role": "system",
                    "content": "あなたは部屋の雰囲気からおすすめの家具の色と理由をカンマ区切りで出力してください\n 例: 赤, この部屋は~"
                },
                {
                    "role": "system",
                    "content": f"色は以下から選んでください".join(color_list)
                },
                {
                    "role": "user",
                    "content": [
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": f"data:image/jpeg;base64,{base64_image}"
                            }
                        }
                    ]
                }
            ],
            max_tokens=300,
        )
        color, reason = response.choices[0].message["content"].split(",")
        color_index = select_color_index(color)
        return {
            "color"     : color_index,
            "reason"    : reason
        }