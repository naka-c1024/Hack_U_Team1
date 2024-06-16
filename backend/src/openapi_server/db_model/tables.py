from sqlalchemy import Column, Integer, String, ForeignKey, Float, Text, Date, Boolean, CheckConstraint
from sqlalchemy.orm import relationship

from openapi_server.db import Base

class Users(Base):
    __tablename__ = 'users'
    
    user_id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String(255), nullable=False, unique=True)
    password_hash = Column(String(255), nullable=False)
    area = Column(Integer, nullable=False)

    furniture = relationship("Furniture", back_populates="user")
    trades_received = relationship("Trades", foreign_keys="[Trades.receiver_id]", back_populates="receiver")
    favorites = relationship("Favorites", back_populates="user")


class Furniture(Base):
    __tablename__ = 'furniture'
    
    furniture_id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    product_name = Column(String(255), nullable=False)
    image = Column(String(255), nullable=False)
    description = Column(Text)
    height = Column(Float, nullable=False)
    width = Column(Float, nullable=False)
    depth = Column(Float, nullable=False)
    category = Column(Integer, nullable=False)
    color = Column(Integer, nullable=False)
    condition = Column(Integer, nullable=False)
    trade_status = Column(Integer, nullable=False, server_default="0")
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    trade_place = Column(String(255), nullable=False)

    user = relationship("Users", back_populates="furniture")
    trades = relationship("Trades", back_populates="furniture")
    favorites = relationship("Favorites", back_populates="furniture")

    __table_args__ = (
        CheckConstraint('height >= 0', name='check_height_positive'),
        CheckConstraint('width >= 0', name='check_width_positive'),
        CheckConstraint('depth >= 0', name='check_depth_positive'),
    )


class Trades(Base):
    __tablename__ = 'trades'
    
    trade_id = Column(Integer, primary_key=True, autoincrement=True)
    furniture_id = Column(Integer, ForeignKey('furniture.furniture_id'), nullable=False)
    receiver_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    is_checked = Column(Boolean, nullable=False, server_default="0")
    trade_date = Column(Date)

    furniture = relationship("Furniture", back_populates="trades")
    receiver = relationship("Users", back_populates="trades_received")


class Favorites(Base):
    __tablename__ = 'favorites'
    
    favorite_id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    furniture_id = Column(Integer, ForeignKey('furniture.furniture_id'), nullable=False)

    user = relationship("Users", back_populates="favorites")
    furniture = relationship("Furniture", back_populates="favorites")
