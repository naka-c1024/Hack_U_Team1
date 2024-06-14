from fastapi import APIRouter, HTTPException, Path
from pydantic import BaseModel
from typing import List

router = APIRouter()

class RegisterFurnitureRequest(BaseModel):
    userId: int
    product_name: str
    image: str
    description: str
    size: str
    category: str
    color: str

class FurnitureResponse(BaseModel):
    furniture_id: int
    product_name: str
    image: str
    description: str
    size: str
    category: str
    color: str
    username: str

class FurnitureListResponse(BaseModel):
    furniture: List[FurnitureResponse]

@router.post("/furniture", response_model=FurnitureResponse)
async def register_furniture(furniture_request: RegisterFurnitureRequest):
    # Dummy implementation for the example
    return FurnitureResponse(
        furniture_id=1,
        product_name=furniture_request.product_name,
        image=furniture_request.image,
        description=furniture_request.description,
        size=furniture_request.size,
        category=furniture_request.category,
        color=furniture_request.color,
        username="dummy_user"
    )

@router.get("/furniture", response_model=FurnitureListResponse)
async def get_list_of_furniture():
    # Dummy implementation for the example
    return FurnitureListResponse(furniture=[])

@router.get("/furniture/{furniture_id}", response_model=FurnitureResponse)
async def get_furniture_details(furniture_id: int = Path(..., title="The ID of the furniture to retrieve")):
    # Dummy implementation for the example
    return FurnitureResponse(
        furniture_id=furniture_id,
        product_name="Sample Furniture",
        image="sample_image",
        description="Sample Description",
        size="Sample Size",
        category="Sample Category",
        color="Sample Color",
        username="dummy_user"
    )
