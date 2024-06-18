from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from openapi_server.db import Base
from openapi_server.db_model.tables import Users, Furniture, Trades, Favorites # 明示的にインポートしなければならない
from openapi_server.insert_dummy_data import insert_dummy_data

DB_URL = "mysql+pymysql://root@db:3306/backend?charset=utf8mb4"
engine = create_engine(DB_URL, echo=True)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def reset_database():
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)

    # ダミーデータを挿入, 必要ない場合はコメントアウト
    with SessionLocal() as session:
        insert_dummy_data(session)

if __name__ == "__main__":
    reset_database()
