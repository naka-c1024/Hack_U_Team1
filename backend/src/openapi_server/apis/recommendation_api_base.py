# coding: utf-8

from typing import ClassVar, Dict, List, Tuple  # noqa: F401

from openapi_server.models.recommend_request import RecommendRequest
from openapi_server.models.recommend_response import RecommendResponse


class BaseRecommendationApi:
    subclasses: ClassVar[Tuple] = ()

    def __init_subclass__(cls, **kwargs):
        super().__init_subclass__(**kwargs)
        BaseRecommendationApi.subclasses = BaseRecommendationApi.subclasses + (cls,)
    def recommend_get(
        self,
        recommend_request: RecommendRequest,
    ) -> RecommendResponse:
        ...
