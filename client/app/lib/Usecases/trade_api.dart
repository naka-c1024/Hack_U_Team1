import 'dart:convert';
import 'package:http/http.dart';

import '../Domain/trade.dart';

// 取引リストを取得
Future<List<Trade>> getTradeList(int userId) async {
  try {
    final url = Uri.parse('http://192.168.2.142:8080/trades');
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
          image: base64Decode(item['image']),
          receiverName: item['receiver_name'],
          productName: item['product_name'],
          furnitureId: item['furniture_id'],
          giverId: item['giver_id'],
          receiverId: item['receiver_id'],
          isChecked: item['is_checked'],
          giverApproval: item['giver_approval'],
          receiverApproval: item['receiver_approval'],
          tradeDate: item['trade_date_time'] == null
              ? DateTime.now()
              : DateTime.parse(item['trade_date_time']),
          tradePlace: item['trade_place'],
        );
        tradeList.add(trade);
      }
      return tradeList;
    } else if (response.statusCode == 404) {
      return [];
    } else {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to get trade list: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}

// 取引を承認
Future<void> requestTrade(int furnitureId, int userId, DateTime tradeDate) async {
  try {
    final url = Uri.parse('http://192.168.2.142:8080/trades');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'furniture_id': furnitureId,
        'user_id': userId,
        'trade_date_time': tradeDate.toIso8601String(),
      };
    final jsonBody = json.encode(body);
    final response = await post(url, headers: headers, body: jsonBody);
    final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200) {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to request trade: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}

// 取引を承認
Future<void> approveTrade(int tradeId, bool isGiver) async {
  try {
    final url = Uri.parse('http://192.168.2.142:8080/trades/$tradeId');
    final headers = {'Content-Type': 'application/json'};
    final body = {
      'is_giver': isGiver,
    };
    final jsonBody = json.encode(body);
    final response = await put(url, headers: headers, body: jsonBody);
    final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200) {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to approve trade: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}

// 取引を確認
Future<void> checkTrade(int tradeId, bool isGiver) async {
  try {
    final url = Uri.parse('http://192.168.2.142:8080/trades/$tradeId/isChecked');
    final headers = {'Content-Type': 'application/json'};
    final body = {
      'is_checked': true,
    };
    final jsonBody = json.encode(body);
    final response = await put(url, headers: headers, body: jsonBody);
    final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200) {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to check trade: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}
