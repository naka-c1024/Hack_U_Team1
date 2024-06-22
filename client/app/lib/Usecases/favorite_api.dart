import 'dart:convert';
import 'package:http/http.dart';

// いいねを追加
Future<void> addFavorite(int userId, int furnitureId) async {
  try {
    final uri =
        Uri.parse('http://localhost:8080/favorite').replace(queryParameters: {
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
        Uri.parse('http://localhost:8080/favorite').replace(queryParameters: {
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
