import 'dart:convert';
import 'package:http/http.dart';

import '../Domain/trade.dart';

// 取引リストを取得
Future<List<Trade>> getTradeList(int userId) async {
  try {
    final url = Uri.parse('http://localhost:8080/trades');
    final params = {
      'user_id': userId.toString(),
    };
    final uri = Uri.parse(url.toString()).replace(queryParameters: params);
    final response = await get(uri);
    final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      final items = jsonResponse['trades'];
      List<Trade> tradeList = [];
      for (Map<String, dynamic> item in items) {
        var trade = Trade(
          tradeId: item['trade_id'] ?? 0,
          image: null,//base64Decode(item['image']),
          receiverName: item['receiver_name'],
          productName: item['product_name'],
          furnitureId: item['furniture_id'],
          giverId: item['giver_id'],
          receiverId: item['receiver_id'],
          isChecked: item['is_checked'],
          giverApproval: item['giver_approval'],
          receiverApproval: item['receiver_approval'],
          tradeDate: item['trade_date'] == null
              ? DateTime.now()
              : DateTime.parse(item['trade_date']),
          tradePlace: item['trade_place'],
        );
        tradeList.add(trade);
      }
      return tradeList;
    } else if (response.statusCode == 404){
      return [];
    } else {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to get trade list: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}
