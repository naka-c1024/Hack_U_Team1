from sqlalchemy import Column, Integer, String, Float, Text, Boolean, Date, DateTime, ForeignKey, CheckConstraint, UniqueConstraint, text
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
    is_sold = Column(Boolean, nullable=False, server_default=text("False"))
    start_date = Column(Date)
    end_date = Column(Date)
    trade_place = Column(String(255), nullable=False)
    
    user = relationship("Users", back_populates="furniture")
    trades = relationship("Trades", back_populates="furniture")
    favorites = relationship("Favorites", back_populates="furniture", cascade="all, delete-orphan")
    
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
    is_checked = Column(Boolean, nullable=False, server_default=text("False"))
    giver_approval = Column(Boolean, nullable=False, server_default=text("False"))
    receiver_approval = Column(Boolean, nullable=False, server_default=text("False"))
    trade_date_time = Column(DateTime)
    
    furniture = relationship("Furniture", back_populates="trades")
    receiver = relationship("Users", back_populates="trades_received")

class Favorites(Base):
    __tablename__ = 'favorites'
    
    favorite_id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('users.user_id'), nullable=False)
    furniture_id = Column(Integer, ForeignKey('furniture.furniture_id'), nullable=False)
    
    user = relationship("Users", back_populates="favorites")
    furniture = relationship("Furniture", back_populates="favorites")
    
    __table_args__ = (
        UniqueConstraint('user_id', 'furniture_id', name='unique_favorite'),
    )
