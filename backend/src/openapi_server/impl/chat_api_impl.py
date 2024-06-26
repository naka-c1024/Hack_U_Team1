from typing import List, Dict
from dateutil import parser
import pytz
from datetime import datetime

from fastapi import (  # noqa: F401
    WebSocket,
    WebSocketDisconnect,
    HTTPException,
    status,
)
from sqlalchemy.ext.asyncio import AsyncSession

from openapi_server.apis.chat_api_base import BaseChatApi
from openapi_server.models.chat_list_response import ChatListResponse
from openapi_server.models.chat_response import ChatResponse
import openapi_server.cruds.chat as chat_crud


class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[int, WebSocket] = {}

    async def connect(self, websocket: WebSocket, client_id: int):
        await websocket.accept()
        self.active_connections[client_id] = websocket

    def disconnect(self, client_id: int):
        del self.active_connections[client_id]

    async def send_message(self, message: dict, client_id: int):
        if client_id in self.active_connections:
            await self.active_connections[client_id].send_json(message)

manager = ConnectionManager()

class ChatApiImpl(BaseChatApi):
    async def chat_sender_id_receiver_id_get(
        self,
        sender_id: int,
        receiver_id: int,
        db: AsyncSession,
    ) -> ChatListResponse:
        if sender_id == receiver_id:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="sender_id and receiver_id must be different")

        # 最初のやりとりではmessagesが空のリストになるが、その場合はそのまま空のリストを返す
        messages = await chat_crud.get_chat_messages(db, sender_id, receiver_id)
        response_messages = [ChatResponse.from_orm(message) for message in messages]
        return ChatListResponse(chats=response_messages)

    async def chat_ws_websocket(
        self,
        websocket: WebSocket,
        client_id: int,
        db: AsyncSession,
    ) -> None:
        await manager.connect(websocket, client_id)
        try:
            while True:
                data = await websocket.receive_json()
                sender_id: int = data["sender_id"]
                receiver_id: int = data["receiver_id"]
                message: str = data["message"]
                send_date_time: str = data["send_date_time"]

                send_date_time_jst: datetime = parser.parse(send_date_time).astimezone(pytz.timezone('Asia/Tokyo'))

                await chat_crud.add_chat_message(db, sender_id, receiver_id, message, send_date_time_jst)

                await manager.send_message({"sender_id": sender_id, "message": message, "send_date_time": send_date_time_jst.isoformat()}, receiver_id)
        except WebSocketDisconnect:
            manager.disconnect(client_id)
