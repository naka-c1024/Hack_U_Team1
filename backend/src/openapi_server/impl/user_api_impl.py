from openapi_server.apis.user_api_base import BaseUserApi
from openapi_server.models.login_request import LoginRequest
from openapi_server.models.login_response import LoginResponse
from openapi_server.models.sign_up_request import SignUpRequest

from openapi_server.security_api import authenticate_user

from fastapi import HTTPException, status
from fastapi import Depends

from sqlalchemy.ext.asyncio import AsyncSession

import openapi_server.cruds.user_api as user_crud
from openapi_server.db import get_db

class UserApiImpl(BaseUserApi):
    async def login_post(self, login_request, db):
        user = await authenticate_user(db, login_request.username, login_request.password)
        if not user:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Incorrect username or password")
        return LoginResponse(user_id=user.user_id)

    def logout_post(self):
        return None

    def sign_up_post(self, sign_up_request: SignUpRequest, db: AsyncSession):
        return user_crud.create_user(db, sign_up_request)