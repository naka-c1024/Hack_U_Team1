from typing import List
from datetime import datetime

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.engine import Result

import openapi_server.db_model.tables as db_model


async def get_chat_messages(db: AsyncSession, sender_id: int, receiver_id: int) -> db_model.Chats:
    result: Result = await db.execute(
        select(db_model.Chats).filter(
            ((db_model.Chats.sender_id == sender_id) & (db_model.Chats.receiver_id == receiver_id)) |
            ((db_model.Chats.sender_id == receiver_id) & (db_model.Chats.receiver_id == sender_id))
        )
    )
    messages: List[db_model.Chats] = result.scalars().all()
    return messages


async def add_chat_message(db: AsyncSession, sender_id: int, received_id: int, message: str, send_date_time: datetime) -> None:
    chat = db_model.Chats(sender_id=sender_id, receiver_id=received_id, message=message, send_date_time=send_date_time)
    db.add(chat)
    await db.commit()
