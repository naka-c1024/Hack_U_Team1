from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from openapi_server.db import Base
from openapi_server.db_model.tables import Users, Furniture, Trades, Favorites, Chats # 明示的にインポートしなければならない
from openapi_server.migrate.insert_dummy_data import insert_dummy_data
import os
import shutil

DB_URL = "mysql+pymysql://root@db:3306/backend?charset=utf8mb4"

engine = create_engine(DB_URL, echo=True)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def reset_database():
    # テーブルを全て削除
    Base.metadata.drop_all(bind=engine)

    # /app/src/openapi_server/file_storage 配下のファイルを全て削除(.gitkeepは削除しない)
    directory = '/app/src/openapi_server/file_storage'
    for filename in os.listdir(directory):
        if filename != '.gitkeep':
            file_path = os.path.join(directory, filename)
            if os.path.isfile(file_path):
                os.remove(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)

    # テーブルを作成
    Base.metadata.create_all(bind=engine)

    # ダミーデータを挿入
    with SessionLocal() as session:
        insert_dummy_data(session)


if __name__ == "__main__":
    reset_database()
