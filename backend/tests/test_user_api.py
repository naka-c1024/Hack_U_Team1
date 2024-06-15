# coding: utf-8

from fastapi.testclient import TestClient


from openapi_server.models.login_request import LoginRequest  # noqa: F401
from openapi_server.models.login_response import LoginResponse  # noqa: F401
from openapi_server.models.sign_up_request import SignUpRequest  # noqa: F401


def test_login_post(client: TestClient):
    """Test case for login_post

    User login
    """
    login_request = {"password":"password","username":"username"}

    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "POST",
    #    "/login",
    #    headers=headers,
    #    json=login_request,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_logout_post(client: TestClient):
    """Test case for logout_post

    User logout
    """

    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "POST",
    #    "/logout",
    #    headers=headers,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_sign_up_post(client: TestClient):
    """Test case for sign_up_post

    sign up
    """
    sign_up_request = {"password":"password","address":"address","username":"username"}

    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "POST",
    #    "/sign_up",
    #    headers=headers,
    #    json=sign_up_request,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200

