// 取引に関する情報を保持するクラス

class Trade {
  final int tradeId;
  final String imagePath;
  final String receiverName;
  final String productName;
  final String tradePlace;
  final int furnitureId;
  final int giverId;
  final int receiverId;
  final bool isChecked;
  final bool giverApproval;
  final bool receiverApproval;
  final DateTime tradeDate;

  Trade({
    required this.tradeId,
    required this.imagePath,
    required this.receiverName,
    required this.productName,
    required this.tradePlace,
    required this.furnitureId,
    required this.giverId,
    required this.receiverId,
    required this.isChecked,
    required this.giverApproval,
    required this.receiverApproval,
    required this.tradeDate,
  });
}
