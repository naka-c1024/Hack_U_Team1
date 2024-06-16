from sqlalchemy import create_engine

from openapi_server.db import Base
from openapi_server.db_model.tables import Users, Furniture, Trades, Favorites # 明示的にインポートしなければならない

DB_URL = "mysql+pymysql://root@db:3306/backend?charset=utf8"
engine = create_engine(DB_URL, echo=True)


def reset_database():
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)


if __name__ == "__main__":
    reset_database()
