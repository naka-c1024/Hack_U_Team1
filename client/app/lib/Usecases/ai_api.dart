import 'dart:convert';
import 'package:http/http.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Domain/description.dart';

// AIが返してくれた家具の説明を保持
final descriptionProvider =
    StateProvider.autoDispose<Description?>((ref) => null);

// 家具の説明を取得
Future<void> describeFurniture(WidgetRef ref, String imagePath) async {
  ref.watch(descriptionProvider.notifier).state = null;
  try {
    final uri = Uri.parse('http://192.168.2.142:8080/furniture/describe');
    final request = MultipartRequest('POST', uri);
    // テスト用の画像を読み込む
    var file = await MultipartFile.fromPath('image', imagePath);
    request.files.add(file);
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final jsonResponse = jsonDecode(responseBody);
    if (response.statusCode == 200) {
      final description = Description(
        productName: jsonResponse['product_name'],
        description: jsonResponse['description'],
        category: jsonResponse['category'],
        color: jsonResponse['color'],
      );
      ref.read(descriptionProvider.notifier).state = description;
    } else {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to get furniture list: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}
