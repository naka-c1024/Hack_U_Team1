# coding: utf-8

from typing import List, Tuple, Optional  # noqa: F401

from fastapi import Depends, Security  # noqa: F401
from fastapi.openapi.models import OAuthFlowImplicit, OAuthFlows  # noqa: F401
from fastapi.security import (  # noqa: F401
    HTTPAuthorizationCredentials,
    HTTPBasic,
    HTTPBasicCredentials,
    HTTPBearer,
    OAuth2,
    OAuth2AuthorizationCodeBearer,
    OAuth2PasswordBearer,
    SecurityScopes,
)
from fastapi.security.api_key import APIKeyCookie, APIKeyHeader, APIKeyQuery  # noqa: F401

from openapi_server.models.extra_models import TokenModel

from passlib.context import CryptContext

from sqlalchemy.engine import Result
from sqlalchemy import select

from openapi_server.db_model.tables import Users

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

async def authenticate_user(db, username: str, password: str):
    result: Result = await (
        db.execute(
            select(
                Users
            ).where(
                Users.username == username
            )
        )
    )
    user: Optional[Tuple[Users]] = result.first()
    if not user:
        return False
    if not verify_password(password, user[0].password_hash):
        return False
    return user[0]