from openapi_server.apis.ok_api_base import BaseOKApi
from openapi_server.models.ok_response import OKResponse

class OKApiImpl(BaseOKApi):
    def ok_get(self) -> OKResponse:
        return OKResponse(msg="API is running")
