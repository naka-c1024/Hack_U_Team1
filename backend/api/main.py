from fastapi import FastAPI

from api.routers import ok, user, furniture, trade

app = FastAPI()
app.include_router(ok.router, tags=["OK"])
app.include_router(user.router, tags=["User"])
app.include_router(furniture.router, tags=["Furniture"])
app.include_router(trade.router, tags=["Trade"])
