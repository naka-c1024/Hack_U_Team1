// 家具に関する情報を保持するクラス

import 'dart:typed_data';

class Furniture {
  final int? furnitureId;
  final String productName;
  final Uint8List? image; // 画像はバイナリ型で保持
  final String description;
  final double height;
  final double width;
  final double depth;
  final int category; // コードで管理
  final int color; // コードで管理
  final int condition; // コードで管理
  final String userName;
  final int area; // コードで管理
  final DateTime? startDate;
  final DateTime? endDate;
  final String tradePlace;
  final bool isSold;
  final bool isFavorite;

  Furniture({
    this.furnitureId,
    required this.productName,
    this.image,
    required this.description,
    required this.height,
    required this.width,
    required this.depth,
    required this.category,
    required this.color,
    required this.condition,
    required this.userName,
    required this.area,
    this.startDate,
    this.endDate,
    required this.tradePlace,
    required this.isSold,
    required this.isFavorite,
  });
}
