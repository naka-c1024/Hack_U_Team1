from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from openapi_server.db import Base
from openapi_server.db_model.tables import Users, Furniture, Trades, Favorites, Chats # 明示的にインポートしなければならない
from openapi_server.migrate.insert_dummy_data import insert_dummy_data
import os
import shutil

MYSQL_USER = os.getenv("MYSQL_USER")
MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD")
MYSQL_HOST = os.getenv("MYSQL_HOST")
MYSQL_PORT = os.getenv("MYSQL_PORT")
MYSQL_DATABASE = os.getenv("MYSQL_DATABASE")
if not all([MYSQL_USER, MYSQL_PASSWORD, MYSQL_HOST, MYSQL_PORT, MYSQL_DATABASE]):
    raise ValueError("環境変数が設定されていません")

DB_URL = f"mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DATABASE}?charset=utf8mb4"
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
