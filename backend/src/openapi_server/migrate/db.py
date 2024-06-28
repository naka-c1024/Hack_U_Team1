from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from openapi_server.db import Base
from openapi_server.db_model.tables import Users, Furniture, Trades, Favorites, Chats # 明示的にインポートしなければならない
from openapi_server.migrate.insert_dummy_data import insert_dummy_data
from openapi_server.object_storage.minio import minio_client


DB_URL = "mysql+pymysql://root@db:3306/backend?charset=utf8mb4"
engine = create_engine(DB_URL, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def reset_database():
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)


def reset_object_storage():
    minio_client.delete_bucket_and_contents()
    minio_client.create_bucket()


if __name__ == "__main__":
    reset_object_storage()
    reset_database()

    with SessionLocal() as session:
        insert_dummy_data(session)
