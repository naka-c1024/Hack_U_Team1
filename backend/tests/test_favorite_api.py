# coding: utf-8

from fastapi.testclient import TestClient


from openapi_server.models.error_response import ErrorResponse  # noqa: F401
from openapi_server.models.favorite_response import FavoriteResponse  # noqa: F401


def test_favorite_delete(client: TestClient):
    """Test case for favorite_delete

    Delete favorite
    """
    params = [("furniture_id", 56),     ("user_id", 56)]
    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "DELETE",
    #    "/favorite",
    #    headers=headers,
    #    params=params,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_favorite_furniture_id_get(client: TestClient):
    """Test case for favorite_furniture_id_get

    Get favorite status
    """

    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/favorite/{furniture_id}/".format(furniture_id=56),
    #    headers=headers,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_favorite_post(client: TestClient):
    """Test case for favorite_post

    Add favorite
    """
    params = [("furniture_id", 56),     ("user_id", 56)]
    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "POST",
    #    "/favorite",
    #    headers=headers,
    #    params=params,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200

