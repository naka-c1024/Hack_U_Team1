import openai
import json
import base64
from pathlib import Path

# OpenAI APIキーをロード
def load_api_key(file_path="secret.json"):
    with open(file_path, 'r') as file:
        secrets = json.load(file)
    return secrets['OPENAI_API_KEY']

# 製品情報データをロード
def load_product_data(file_path="product_data.json"):
    with open(file_path, 'r') as file:
        product_data = json.load(file)
    return product_data

# 画像をBase64でエンコード
def encode_image_to_base64(image_path: str):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

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
    
    def get_describe(self, image_path: str):
        # 画像をBase64エンコード
        base64_image = encode_image_to_base64(image_path)
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
            "color"         : (color_idx, color),
            "category"      : (category_idx, category)
        }

class FurnitureRecommendation:
    def __init__(self):
        openai.api_key = load_api_key()
        self.product_data = load_product_data()
    
    def get_recommend_color(self, image_path: str):
        color_list = self.product_data['colors']

        # 画像をBase64エンコード
        base64_image = encode_image_to_base64(image_path)
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
            "color"     : (color_index, color),
            "reason"    : reason
        }

if __name__ == '__main__':
    recommend_model = FurnitureRecommendation()
    describe_model = FurnitureDescribe()
    print("レコメンドモデルのテスト")
    for _ in range(3):
        try:
            recommend = recommend_model.get_recommend_color('recommend_example.jpg')
            print(recommend)
            break
        except Exception as e:
            print(e)
            print("Retry")
    
    print("説明モデルのテスト")
    for _ in range(3):
        try:
            describe = describe_model.get_describe('describe_example.jpg')
            print(describe)
            break
        except Exception as e:
            print(e)
            print("Retry")