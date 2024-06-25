# coding: utf-8

from typing import ClassVar, Dict, List, Tuple  # noqa: F401

from openapi_server.models.chat_list_response import ChatListResponse
from openapi_server.models.error_response import ErrorResponse


class BaseChatApi:
    subclasses: ClassVar[Tuple] = ()

    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        BaseChatApi.subclasses = BaseChatApi.subclasses + (cls,)
    def chat_sender_id_receiver_id_get(
        self,
        sender_id: int,
        receiver_id: int,
    ) -> ChatListResponse:
        ...
