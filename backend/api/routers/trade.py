from fastapi import APIRouter, HTTPException, Path
from pydantic import BaseModel
from typing import List

router = APIRouter()

class RequestTradeRequest(BaseModel):
    furnitureId: int
    userId: int

class TradeResponse(BaseModel):
    tradeId: int
    image: str
    furnitureId: int
    giverId: int
    receiverId: int
    status: str

class TradeListResponse(BaseModel):
    trades: List[TradeResponse]

class UpdateTradeRequest(BaseModel):
    status: str

@router.post("/trades", response_model=TradeResponse)
async def request_trade(trade_request: RequestTradeRequest):
    # Dummy implementation for the example
    return TradeResponse(
        tradeId=1,
        image="sample_image",
        furnitureId=trade_request.furnitureId,
        giverId=trade_request.userId,
        receiverId=2,
        status="pending"
    )

@router.get("/trades", response_model=TradeListResponse)
async def get_list_of_trades_history():
    # Dummy implementation for the example
    return TradeListResponse(trades=[])

@router.put("/trades/{trade_id}")
async def update_trade_status(trade_id: int, update_request: UpdateTradeRequest):
    # Dummy implementation for the example
    return {"message": "Trade status updated successfully"}
