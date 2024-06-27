import openai

from fastapi import UploadFile

from openapi_server.ai import util

class FurnitureDescribe:
    def __init__(self):
        openai.api_key = util.load_api_key()
        self.product_data = util.load_product_data()
    
    async def get_describe(self, image: UploadFile):
        # 画像をBase64エンコード
        base64_image = await util.encode_image_to_base64(image)
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
                    "content": "例:"+"\n".join(util.get_few_shot_data()["describe_example"])
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
                    ],
                    "temperature": 0.5
                }
            ],
            max_tokens=300,
        )
        name, description, color, category = response.choices[0].message["content"].split(",")
        try:
            color_idx = util.select_color_index(color)
        except:
            color_idx = -1
        try:
            category_idx = util.select_category_index(category)
        except:
            category_idx = -1
        return {
            "product_name"  : name, 
            "description"   : description, 
            "color"         : color_idx,
            "category"      : category_idx
        }

class FurnitureRecommendation:
    def __init__(self):
        openai.api_key = util.load_api_key()
        self.product_data = util.load_product_data()

    async def get_recommend_color(self, image: UploadFile):
        color_list = self.product_data['colors']

        # 画像をBase64エンコード
        base64_image = await util.encode_image_to_base64(image)
        # OpenAI APIリクエストの実行
        response = openai.ChatCompletion.create(
            model="gpt-4o",
            messages=[
                {
                    "role": "system",
                    "content": "あなたは部屋の雰囲気からおすすめの家具の色と理由をカンマ区切りで出力してください"
                },
                {
                    "role": "system",
                    "content": "例："+"\n".join(util.get_few_shot_data()["recommend_example"])
                },
                {
                    "role": "system",
                    "content": f"色は以下から選んでください: {', '.join(color_list)}"
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
                    ],
                    "temperature": 0.5
                }
            ],
            max_tokens=300,
        )
        color, reason = response.choices[0].message["content"].split(",")
        try:
            color_index = util.select_color_index(color)
        except:
            color_index = -1
        return {
            "color"     : color_index,
            "reason"    : reason
        }