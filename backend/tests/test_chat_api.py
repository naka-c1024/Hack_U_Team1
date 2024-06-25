# coding: utf-8

from fastapi.testclient import TestClient


from openapi_server.models.chat_list_response import ChatListResponse  # noqa: F401
from openapi_server.models.error_response import ErrorResponse  # noqa: F401


def test_chat_sender_id_receiver_id_get(client: TestClient):
    """Test case for chat_sender_id_receiver_id_get

    Get chat list
    """

    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/chat/{sender_id}/{receiver_id}".format(sender_id=56, receiver_id=56),
    #    headers=headers,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200

