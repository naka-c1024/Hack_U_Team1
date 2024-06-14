from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()

class OKResponse(BaseModel):
    msg: str

@router.get("/ok", response_model=OKResponse)
async def check_status():
    return OKResponse(msg="API is running")
