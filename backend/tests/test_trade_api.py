# coding: utf-8

from fastapi.testclient import TestClient


from openapi_server.models.request_trade_request import RequestTradeRequest  # noqa: F401
from openapi_server.models.trade_list_response import TradeListResponse  # noqa: F401
from openapi_server.models.update_is_checked_request import UpdateIsCheckedRequest  # noqa: F401
from openapi_server.models.update_trade_request import UpdateTradeRequest  # noqa: F401


def test_trades_get(client: TestClient):
    """Test case for trades_get

    Get list of trades history
    """
    params = [("user_id", 56)]
    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "GET",
    #    "/trades",
    #    headers=headers,
    #    params=params,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_trades_post(client: TestClient):
    """Test case for trades_post

    Request a trade
    """
    request_trade_request = {"furniture_id":0,"user_id":6,"trade_date":"2000-01-23"}

    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "POST",
    #    "/trades",
    #    headers=headers,
    #    json=request_trade_request,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_trades_trade_id_is_checked_put(client: TestClient):
    """Test case for trades_trade_id_is_checked_put

    Update isChecked status
    """
    update_is_checked_request = {"is_checked":1}

    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "PUT",
    #    "/trades/{trade_id}/isChecked".format(trade_id=56),
    #    headers=headers,
    #    json=update_is_checked_request,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200


def test_trades_trade_id_put(client: TestClient):
    """Test case for trades_trade_id_put

    Update trade status
    """
    update_trade_request = {"status":0}

    headers = {
    }
    # uncomment below to make a request
    #response = client.request(
    #    "PUT",
    #    "/trades/{trade_id}".format(trade_id=56),
    #    headers=headers,
    #    json=update_trade_request,
    #)

    # uncomment below to assert the status code of the HTTP response
    #assert response.status_code == 200

