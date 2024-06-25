import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../Domain/furniture.dart';

// 家具リストを取得
Future<List<Furniture>> getFurnitureList(
    int userId, int? category, String? searchWord) async {
  try {
    final url = Uri.parse('http://192.168.2.142:8080/furniture');
    final params = {
      'user_id': userId.toString(),
    };
    if (category != null) {
      params['category'] = category.toString();
    }
    if (searchWord != null && searchWord != '') {
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
    } else if (response.statusCode == 404) {
      return [];
    } else {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to get furniture list: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}

// 家具IDを指定して詳細を取得
Future<Furniture> getFurnitureDetails(int userId, int furnitureId) async {
  try {
    final url = Uri.parse('http://192.168.2.142:8080/furniture/$furnitureId');
    final params = {
      'user_id': userId.toString(),
    };
    final uri = Uri.parse(url.toString()).replace(queryParameters: params);
    final response = await get(uri);
    final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      final item = jsonResponse;
      final furniture = Furniture(
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
      return furniture;
    } else {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to get furniture details: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}

// 家具を登録
Future<void> registerFurniture(int userId, Furniture furniture) async {
  try {
    final uri = Uri.parse('http://192.168.2.142:8080/furniture');
    final request = MultipartRequest('POST', uri);
    // 画像を読み込む
    var file = await MultipartFile.fromPath('image', furniture.imagePath!);
    request.files.add(file);
    // 他のパラメータを設定
    request.fields['user_id'] = userId.toString();
    request.fields['product_name'] = furniture.productName;
    request.fields['description'] = furniture.description;
    request.fields['height'] = furniture.height.toString();
    request.fields['width'] = furniture.width.toString();
    request.fields['depth'] = furniture.depth.toString();
    request.fields['category'] = furniture.category.toString();
    request.fields['color'] = furniture.color.toString();
    if (furniture.startDate != null) {
      request.fields['start_date'] =
          DateFormat('yyyy-MM-dd', 'ja').format(furniture.startDate!);
    }
    if (furniture.endDate != null) {
      request.fields['end_date'] =
          DateFormat('yyyy-MM-dd', 'ja').format(furniture.endDate!);
    }
    request.fields['trade_place'] = furniture.tradePlace;
    request.fields['condition'] = furniture.condition.toString();
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final jsonResponse = jsonDecode(responseBody);
    if (response.statusCode != 200) {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to register furniture: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}

// 家具を削除
Future<void> deleteFurniture(int furnitureId) async {
  try {
    final url = Uri.parse('http://192.168.2.142:8080/furniture/$furnitureId');
    final response = await delete(url);
    final jsonResponse = jsonDecode(response.body);
    if (response.statusCode != 200) {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to get furniture list: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}
