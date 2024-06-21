import 'dart:convert';
import 'package:http/http.dart';
import '../Domain/furniture.dart';

// 家具リストを取得
Future<List<Furniture>> getFurnitureList(int userId, String? searchWord) async {
  try {
    final url = Uri.parse('http://localhost:8080/furniture');
    final params = {
      'user_id': '0',
    };
    if (searchWord != null) {
      params['keyword'] = searchWord;
    }
    final uri = Uri.parse(url.toString()).replace(queryParameters: params);
    final response = await get(uri);
    final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      final items = jsonResponse['furniture'];
      List<Furniture> furnitureList = [];
      for (Map<String, dynamic> item in items) {
        var furniture = Furniture(
            furnitureId: item['furniture_id'],
            image: base64Decode(item['image']),
            area: item['area'],
            userName: item['username'],
            productName: item['product_name'],
            description: item['description'],
            height: double.parse(item['size'].split(' ')[0]),
            width: double.parse(item['size'].split(' ')[1]),
            depth: double.parse(item['size'].split(' ')[2]),
            category: item['category'],
            color: item['color'],
            condition: item['condition'],
            isSold: item['is_sold'],
            startDate: item['start_date'] == null
                ? null
                : DateTime.parse(item['start_date']),
            endDate: item['end_date'] == null
                ? null
                : DateTime.parse(item['end_date']),
            tradePlace: item['trade_place'],
            isFavorite: item['is_favorite']);
        furnitureList.add(furniture);
      }
      return furnitureList;
    } else {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to get furniture list: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}
