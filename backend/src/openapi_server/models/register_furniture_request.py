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
from pydantic import BaseModel, ConfigDict, Field, StrictBytes, StrictFloat, StrictInt, StrictStr
from typing import Any, ClassVar, Dict, List, Union
try:
    from typing import Self
except ImportError:
    from typing_extensions import Self

class RegisterFurnitureRequest(BaseModel):
    """
    RegisterFurnitureRequest
    """ # noqa: E501
    user_id: StrictInt = Field(alias="userId")
    product_name: StrictStr
    image: Union[StrictBytes, StrictStr]
    description: StrictStr
    height: Union[StrictFloat, StrictInt]
    width: Union[StrictFloat, StrictInt]
    depth: Union[StrictFloat, StrictInt]
    category: StrictInt
    color: StrictInt = Field(description="色コード, URL(https://github.com/naka-c1024/Hack_U_Team1/blob/main/client/app/lib/constants.dart)")
    start_date: date
    end_date: date
    trade_place: StrictStr
    condition: StrictInt
    __properties: ClassVar[List[str]] = ["userId", "product_name", "image", "description", "height", "width", "depth", "category", "color", "start_date", "end_date", "trade_place", "condition"]

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
        """Create an instance of RegisterFurnitureRequest from a JSON string"""
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
        """Create an instance of RegisterFurnitureRequest from a dict"""
        if obj is None:
            return None

        if not isinstance(obj, dict):
            return cls.model_validate(obj)

        _obj = cls.model_validate({
            "userId": obj.get("userId"),
            "product_name": obj.get("product_name"),
            "image": obj.get("image"),
            "description": obj.get("description"),
            "height": obj.get("height"),
            "width": obj.get("width"),
            "depth": obj.get("depth"),
            "category": obj.get("category"),
            "color": obj.get("color"),
            "start_date": obj.get("start_date"),
            "end_date": obj.get("end_date"),
            "trade_place": obj.get("trade_place"),
            "condition": obj.get("condition")
        })
        return _obj


