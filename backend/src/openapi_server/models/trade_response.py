# coding: utf-8

"""
    家具マッチングサービス

    画像によるレコメンド機能を添えて

    The version of the OpenAPI document: 1.0.0
    Generated by OpenAPI Generator (https://openapi-generator.tech)

    Do not edit the class manually.
"""  # noqa: E501


from __future__ import annotations
import pprint
import re  # noqa: F401
import json




from datetime import date
from pydantic import BaseModel, ConfigDict, Field, StrictBool, StrictBytes, StrictInt, StrictStr
from typing import Any, ClassVar, Dict, List, Optional, Union
try:
    from typing import Self
except ImportError:
    from typing_extensions import Self

class TradeResponse(BaseModel):
    """
    TradeResponse
    """ # noqa: E501
    trade_id: Optional[StrictInt] = None
    image: Optional[Union[StrictBytes, StrictStr]] = None
    receiver_name: Optional[StrictStr] = None
    product_name: Optional[StrictStr] = None
    trade_place: Optional[StrictStr] = Field(default=None, description="具体的な取引場所")
    furniture_id: Optional[StrictInt] = None
    giver_id: Optional[StrictInt] = None
    receiver_id: Optional[StrictInt] = None
    is_checked: Optional[StrictBool] = None
    giver_approval: Optional[StrictBool] = None
    receiver_approval: Optional[StrictBool] = None
    trade_date: Optional[date] = None
    __properties: ClassVar[List[str]] = ["trade_id", "image", "receiver_name", "product_name", "trade_place", "furniture_id", "giver_id", "receiver_id", "is_checked", "giver_approval", "receiver_approval", "trade_date"]

    model_config = {
        "populate_by_name": True,
        "validate_assignment": True,
        "protected_namespaces": (),
    }


    def to_str(self) -> str:
        """Returns the string representation of the model using alias"""
        return pprint.pformat(self.model_dump(by_alias=True))

    def to_json(self) -> str:
        """Returns the JSON representation of the model using alias"""
        # TODO: pydantic v2: use .model_dump_json(by_alias=True, exclude_unset=True) instead
        return json.dumps(self.to_dict())

    @classmethod
    def from_json(cls, json_str: str) -> Self:
        """Create an instance of TradeResponse from a JSON string"""
        return cls.from_dict(json.loads(json_str))

    def to_dict(self) -> Dict[str, Any]:
        """Return the dictionary representation of the model using alias.

        This has the following differences from calling pydantic's
        `self.model_dump(by_alias=True)`:

        * `None` is only added to the output dict for nullable fields that
          were set at model initialization. Other fields with value `None`
          are ignored.
        """
        _dict = self.model_dump(
            by_alias=True,
            exclude={
            },
            exclude_none=True,
        )
        return _dict

    @classmethod
    def from_dict(cls, obj: Dict) -> Self:
        """Create an instance of TradeResponse from a dict"""
        if obj is None:
            return None

        if not isinstance(obj, dict):
            return cls.model_validate(obj)

        _obj = cls.model_validate({
            "trade_id": obj.get("trade_id"),
            "image": obj.get("image"),
            "receiver_name": obj.get("receiver_name"),
            "product_name": obj.get("product_name"),
            "trade_place": obj.get("trade_place"),
            "furniture_id": obj.get("furniture_id"),
            "giver_id": obj.get("giver_id"),
            "receiver_id": obj.get("receiver_id"),
            "is_checked": obj.get("is_checked"),
            "giver_approval": obj.get("giver_approval"),
            "receiver_approval": obj.get("receiver_approval"),
            "trade_date": obj.get("trade_date")
        })
        return _obj


