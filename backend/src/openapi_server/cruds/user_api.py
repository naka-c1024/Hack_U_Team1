from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.engine import Result
from sqlalchemy.future import select

from typing import Optional

import openapi_server.db_model.tables as users_table
import openapi_server.models.sign_up_request as sign_up_request_schema

from openapi_server.security_api import get_password_hash

async def create_user(
    db: AsyncSession, user_create: sign_up_request_schema.SignUpRequest
) -> users_table.Users:
    new_user = users_table.Users(
        username        = user_create.username,
        password_hash   = get_password_hash(user_create.password),
        area            = user_create.area,
    )
    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)
    return new_user

async def get_user(db: AsyncSession, user_id: int) -> users_table.Users:
    result: Result = await db.execute(
        select(users_table.Users).where(users_table.Users.user_id == user_id)
    )
    user: Optional[users_table.Users] = result.scalar_one_or_none()

    return user