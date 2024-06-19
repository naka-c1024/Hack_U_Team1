import os
import requests

from sqlalchemy.orm import Session
from openapi_server.db_model.tables import Users, Furniture, Trades, Favorites

def insert_dummy_data(session: Session):
    # ? パスワードのハッシュは適切なものに変更する
    user1 = Users(username='user1', password_hash='hash1', area=1)
    user2 = Users(username='user2', password_hash='hash2', area=2)
    user3 = Users(username='user3', password_hash='hash3', area=3)
    session.add_all([user1, user2, user3])
    session.flush()  # user_idを取得するためにflushする

    # imageにはファイルパスを指定し、画像ファイルをダウンロードして保存する
    save_dir = "/app/src/openapi_server/file_storage"
    image1, image2, image3 = 'chair.png', 'table.png', 'sofa.png'
    download_image(
        url="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhYanGaudOmCByjXQn4ZZ79lj-BKh3Qu_gaL6XC3aEUYDLFeqPPZwAX9beOtA-0y6jS0tCApILOTZ1YQMgcjfc4tCdmXf2rGIuoyHYlpoRzCxjswafsDlhQsBoDwZN8O36peV1HQLptiO7X/s400/chair_wood.png",
        save_dir=save_dir,
        filename=image1
    )
    download_image(url="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjR2Cb3cxpyyGAEPBeeL_chhKY7pDepiHaDY-n0atEjz9-jrVkwayO1HggwWpuZHE61n8-oEgYdvreB16rsYDkS07e6hSFwfpxl2Yc05SmlPsrqy5ft6hGO5aZZCRZ3d43mjnMBL2m8dzU1/s400/chuuka_turntable.png",
        save_dir=save_dir,
        filename=image2
    )
    download_image(
        url="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhM3YxI5TaHc9lGg0WY6QlTLi2BlCaBBH5SS08dGeCzZ0FzoVzqjFDmOW-8rbTCLIJiUW9DbvM9SUcLheKu7YIYeNDghYYExOvxdNG2lO3xg2u6bLifjz6EQ_Fz-rNLhcSThImBTwzxkYB-/s500/kagu_sofa.png",
        save_dir=save_dir,
        filename=image3
    )
    furniture1 = Furniture(user_id=user1.user_id, product_name='木の椅子', image=os.path.join(save_dir, image1), 
                            description='学校で使うような、木でできた椅子(https://www.irasutoya.com/2013/06/blog-post_6467.html)',
                            height=1.0, width=0.5, depth=0.5, category=1, color=1, condition=1, trade_place='東京都千代田区千代田１−１')
    furniture2 = Furniture(user_id=user2.user_id, product_name='中華料理のターンテーブル', image=os.path.join(save_dir, image2), 
                            description='中華料理を食べるときに使われる回転する円卓(https://www.irasutoya.com/2017/07/blog-post_465.html)',
                            height=0.75, width=1.5, depth=0.75, category=2, color=2, condition=2, trade_place='東京都千代田区 霞が関2丁目1番2号')
    furniture3 = Furniture(user_id=user3.user_id, product_name='ソファ', image=os.path.join(save_dir, image3), 
                            description='かわいいクリーム色のソファ(https://www.irasutoya.com/2013/01/blog-post_6531.html)',
                            height=1.0, width=1.0, depth=1.0, category=1, color=1, condition=1, trade_place='東京都千代田区千代田１−１')
    session.add_all([furniture1, furniture2, furniture3])
    session.flush()  # furniture_idを取得するためにflushする

    trade1 = Trades(furniture_id=furniture1.furniture_id, receiver_id=user2.user_id)
    trade2 = Trades(furniture_id=furniture2.furniture_id, receiver_id=user1.user_id)
    session.add_all([trade1, trade2])


    favorite1 = Favorites(user_id=user1.user_id, furniture_id=furniture2.furniture_id)
    favorite2 = Favorites(user_id=user2.user_id, furniture_id=furniture1.furniture_id)
    session.add_all([favorite1, favorite2])

    session.commit()

def download_image(url, save_dir, filename):
    if not os.path.exists(save_dir):
        raise FileNotFoundError(f"Directory not found: {save_dir}")

    file_path = os.path.join(save_dir, filename)
    if os.path.exists(file_path):
        print(f"Image already exists at {file_path}, skipping download.")
        return

    # 画像を取得
    response = requests.get(url)
    # リクエストが成功したか確認
    response.raise_for_status()

    # 画像を保存
    with open(file_path, 'wb') as file:
        file.write(response.content)
    print(f"Image saved to {file_path}")
