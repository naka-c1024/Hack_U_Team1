import 'dart:convert';
import 'package:http/http.dart';

import '../Domain/constants.dart';

// いいねを追加
Future<void> addFavorite(int userId, int furnitureId) async {
  try {
    final uri =
        Uri.parse('http://$ipAddress:8080/favorite').replace(queryParameters: {
      'furniture_id': furnitureId.toString(),
      'user_id': userId.toString(),
    });
    final headers = {'Content-Type': 'application/json'};
    var response = await post(uri, headers: headers);
    final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200) {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to add favorite: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}

// いいねを削除
Future<void> deleteFavorite(int userId, int furnitureId) async {
  try {
    final uri =
        Uri.parse('http://$ipAddress:8080/favorite').replace(queryParameters: {
      'furniture_id': furnitureId.toString(),
      'user_id': userId.toString(),
    });
    final headers = {'Content-Type': 'application/json'};
    var response = await delete(uri, headers: headers);
    final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200) {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to add favorite: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}

// いいね数を取得
Future<int> getFavoriteCount(int furnitureId) async {
  try {
    final uri = Uri.parse('http://$ipAddress:8080/favorite/$furnitureId/');
    final headers = {'Content-Type': 'application/json'};
    var response = await get(uri, headers: headers);
    final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      final favoriteCount = jsonResponse['favorites_count'];
      return favoriteCount;
    } else {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to add favorite: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}
