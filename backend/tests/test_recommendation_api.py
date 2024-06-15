# coding: utf-8

from fastapi.testclient import TestClient


from openapi_server.models.recommend_request import RecommendRequest  # noqa: F401
from openapi_server.models.recommend_response import RecommendResponse  # noqa: F401


def test_recommend_post(client: TestClient):
    """Test case for recommend_post

    Get furniture recommendations based on room photo
    """
    recommend_request = {"room_photo":"roomPhoto"}

    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "POST",
    #    "/recommend",
    #    headers=headers,
    #    json=recommend_request,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200

