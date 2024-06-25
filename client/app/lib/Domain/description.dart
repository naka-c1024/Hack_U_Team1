// AIに考えてもらった家具の情報を保持するクラス

class Description {
  final String productName;
  final String description;
  final int category; // コードで管理
  final int color; // コードで管理

  Description({
    required this.productName,
    required this.description,
    required this.category,
    required this.color,
  });
}
