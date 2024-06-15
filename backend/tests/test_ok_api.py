# coding: utf-8

from fastapi.testclient import TestClient


from openapi_server.models.ok_response import OKResponse  # noqa: F401


def test_ok_get(client: TestClient):
    """Test case for ok_get

    Check API status
    """

    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/ok",
    #    headers=headers,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200

