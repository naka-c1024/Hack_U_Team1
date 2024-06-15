# coding: utf-8

from fastapi.testclient import TestClient


from openapi_server.models.furniture_list_response import FurnitureListResponse  # noqa: F401
from openapi_server.models.furniture_response import FurnitureResponse  # noqa: F401
from openapi_server.models.register_furniture_request import RegisterFurnitureRequest  # noqa: F401


def test_furniture_furniture_id_delete(client: TestClient):
    """Test case for furniture_furniture_id_delete

    Delete furniture
    """

    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "DELETE",
    #    "/furniture/{furniture_id}".format(furniture_id=56),
    #    headers=headers,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_furniture_furniture_id_get(client: TestClient):
    """Test case for furniture_furniture_id_get

    Get furniture details
    """

    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/furniture/{furniture_id}".format(furniture_id=56),
    #    headers=headers,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_furniture_get(client: TestClient):
    """Test case for furniture_get

    Get list of furniture
    """
    params = [("user_id", 56)]
    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/furniture",
    #    headers=headers,
    #    params=params,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_furniture_post(client: TestClient):
    """Test case for furniture_post

    Register new furniture
    """
    register_furniture_request = {"end_date":"2000-01-23","image":"","color":"color","description":"description","trade_place":"trade_place","user_id":0,"product_name":"product_name","condition":5,"depth":5.962133916683182,"width":1.4658129805029452,"category":"category","height":6.027456183070403,"start_date":"2000-01-23"}
    params = [("user_id", 56)]
    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "POST",
    #    "/furniture",
    #    headers=headers,
    #    json=register_furniture_request,
    #    params=params,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200

