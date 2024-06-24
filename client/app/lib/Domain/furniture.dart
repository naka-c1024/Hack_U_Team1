// 家具に関する情報を保持するクラス

import 'dart:typed_data';

class Furniture {
  final int? furnitureId;
  final String productName;
  final Uint8List? image; // 画像はバイナリ型で保持
  final String? imagePath; // 画像登録時はパスを渡す
  final String description;
  final double height;
  final double width;
  final double depth;
  final int category; // コードで管理
  final int color; // コードで管理
  final int condition; // コードで管理
  final String userName;
  final int area; // コードで管理
  DateTime? startDate;
  DateTime? endDate;
  String tradePlace;
  final bool isSold;
  final bool isFavorite;

  Furniture({
    this.furnitureId,
    required this.productName,
    this.image,
    this.imagePath,
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

  void updateTradeParams({
    required String tradePlace,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    this.tradePlace = tradePlace;
    this.startDate = startDate;
    this.endDate = endDate;
  }
}
