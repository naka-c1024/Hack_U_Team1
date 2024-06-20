import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import '../Domain/furniture.dart';

Uint8List convertImage (String str) {
  List<int> bytes = utf8.encode(str);
  Uint8List uint8list = Uint8List.fromList(bytes);
  return uint8list;
}

// 家具リストを取得
Future<List<Furniture>> getFurnitureList(int userId) async {
  try {
    final request = Request(
      'GET',
      Uri.parse('http://localhost:8080/furniture'),
    )..headers.addAll({
        'Content-Type': 'application/json',
      });
    final requestBody = {
      'user_id': userId,
      'keyword': '',
    };
    request.body = jsonEncode(requestBody);
    StreamedResponse response = await request.send();
    final jsonResponse = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      final items = jsonResponse['furniture'];
      List<Furniture> furnitureList = [];
      for (Map<String, dynamic> item in items) {
        var furniture = Furniture(
            furnitureId: item['furniture_id'],
            image: convertImage(item['image']),
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
            startDate: item['start_date'] == null ? null : DateTime.parse(item['start_date']),
            endDate:item['end_date'] == null ? null :  DateTime.parse(item['end_date']),
            tradePlace: item['trade_place'],
            isFavorite: true); //item['is_favorite']);
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
