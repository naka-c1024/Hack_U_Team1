import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final userName = DateTime.now().toString();

  test('Test: API is running', () async {
    final url = Uri.parse('http://localhost:8080/ok');
    final response = await get(url);
    expect(response.statusCode, 200);
  });

  group('User Account Test', () {
    test('Test: User registered successfully', () async {
      final url = Uri.parse('http://localhost:8080/sign_up');
      final headers = {'Content-Type': 'application/json'};
      final requestBody = jsonEncode({
        'username': userName,
        'password': 'password',
        'area': 0,
      });
      final response = await post(url, headers: headers, body: requestBody);
      expect(response.statusCode, 200);
    });
    test('Test: User registered failed', () async {
      final url = Uri.parse('http://localhost:8080/sign_up');
      final headers = {'Content-Type': 'application/json'};
      final requestBody = jsonEncode({
        'username': userName,
        'password': 'password',
        'area': 0,
      });
      final response = await post(url, headers: headers, body: requestBody);
      expect(response.statusCode, 500);
    });
    test('Test: User login successfully', () async {
      final url = Uri.parse('http://localhost:8080/login');
      final headers = {'Content-Type': 'application/json'};
      final requestBody = jsonEncode({
        'username': userName,
        'password': 'password',
      });
      final response = await post(url, headers: headers, body: requestBody);
      expect(response.statusCode, 200);
      final jsonResponse = jsonDecode(response.body);
      final userId = jsonResponse['userId'];
      expect(userId, isA<int>()); // int型が返ってくることを確認
    });
    test('Test: User login failed', () async {
      final url = Uri.parse('http://localhost:8080/login');
      final headers = {'Content-Type': 'application/json'};
      final requestBody = jsonEncode({
        'username': userName,
        'password': 'not_password',
      });
      final response = await post(url, headers: headers, body: requestBody);
      expect(response.statusCode, 401);
    });
  });

  group('Furniture Test', () {
    var furnitureId = 0;
    test('Test: Get furniture list successfully', () async {
      final url = Uri.parse('http://localhost:8080/furniture');
      final params = {
        'user_id': '0',
      };
      final uri = Uri.parse(url.toString()).replace(queryParameters: params);
      final response = await get(uri);
      expect(response.statusCode, 200);
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final furnitureList = jsonResponse['furniture'];
      expect(furnitureList.length, isNonZero);
    });

    test('Test: Search furniture by keyword', () async {
      final url = Uri.parse('http://localhost:8080/furniture');
      final params = {
        'user_id': '0',
        'keyword': 'ソファ',
      };
      final uri = Uri.parse(url.toString()).replace(queryParameters: params);
      final response = await get(uri);
      expect(response.statusCode, 200);
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final furnitureList = jsonResponse['furniture'];
      expect(furnitureList.length, 1);
      final furniture = furnitureList[0];
      expect(furniture['product_name'], 'ソファ');
      furnitureId = furniture['furniture_id'];
    });

    test('Test: Search furniture by keyword : result 0', () async {
      final url = Uri.parse('http://localhost:8080/furniture');
      final params = {
        'user_id': '0',
        'keyword': 'qwerty',
      };
      final uri = Uri.parse(url.toString()).replace(queryParameters: params);
      final response = await get(uri);
      expect(response.statusCode, 200);
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final furnitureList = jsonResponse['furniture'];
      expect(furnitureList.length, 0);
    });

    test('Test: Get furniture details successfully', () async {
      final url = Uri.parse('http://localhost:8080/furniture/$furnitureId');
      final params = {
        'user_id': '0',
      };
      final uri = Uri.parse(url.toString()).replace(queryParameters: params);
      final response = await get(uri);
      expect(response.statusCode, 200);
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final productName = jsonResponse['product_name'];
      expect(productName, 'ソファ');
    });

    test('Test: Get furniture details failed', () async {
      final url = Uri.parse('http://localhost:8080/furniture/0');
      final params = {
        'user_id': '0',
      };
      final uri = Uri.parse(url.toString()).replace(queryParameters: params);
      final response = await get(uri);
      expect(response.statusCode, 404);
    });

    // test('Test: Register furniture successfully', () async {
    //   final url = Uri.parse('http://localhost:8080/furniture');
    //   final request = MultipartRequest('POST', url);
    //   // テスト用の画像を読み込む
    //   final file = File(
    //       '/Users/ibuki/StudioProjects/Hack_U_Team1/backend/src/openapi_server/file_storage/chair.png');
    //   List<int> imgBytes = await file.readAsBytes();
    //   String imgBase64 = base64Encode(imgBytes);
    //   request.files
    //       .add(MultipartFile.fromString('image',imgBase64));
    //   // // 他のパラメータを設定
    //   request.fields['user_id'] = '1';
    //   request.fields['product_name'] = 'ナチュラルな棚';
    //   request.fields['description'] = 'ものがたくさん置けるナチュラルな棚です。';
    //   request.fields['height'] = '160';
    //   request.fields['width'] = '200';
    //   request.fields['depth'] = '30';
    //   request.fields['category'] = '5';
    //   request.fields['color'] = '0';
    //   // request.fields['start_date'] = '2024-06-21';
    //   // request.fields['end_date'] = '2024-07-21';
    //   request.fields['trade_place'] = '東京都千代田区千代田１−１';
    //   request.fields['condition'] = '0';
    //   final response = await request.send();
    //   expect(response.statusCode, 200);
    // });
  });

  group('Trade Test', () {
    var tradeId = 1;
    test('Test: Request trade successfully', () async {
      final url = Uri.parse('http://localhost:8080/trades');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'furniture_id': 1,
        'user_id': 1,
        'trade_date': '2024-06-22',
      };
      final jsonBody = json.encode(body);
      var response = await post(url, headers: headers, body: jsonBody);
      expect(response.statusCode, 200);
    });

    test('Test: Request trade failed', () async {
      final url = Uri.parse('http://localhost:8080/trades');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'furniture_id': 100000,
        'user_id': 1,
        'trade_date': '2024-06-22',
      };
      final jsonBody = json.encode(body);
      var response = await post(url, headers: headers, body: jsonBody);
      expect(response.statusCode, 500);
    });

    test('Test: Get trade list successfully', () async {
      final url = Uri.parse('http://localhost:8080/trades');
      final params = {
        'user_id': '0',
      };
      final uri = Uri.parse(url.toString()).replace(queryParameters: params);
      final response = await get(uri);
      expect(response.statusCode, 200);
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final tradeList = jsonResponse['trades'];
      expect(tradeList.length, isNonZero);
    });

    test('Test: Get trade list : result 0', () async {
      final url = Uri.parse('http://localhost:8080/trades');
      final params = {
        'user_id': '-1',
      };
      final uri = Uri.parse(url.toString()).replace(queryParameters: params);
      final response = await get(uri);
      expect(response.statusCode, 404);
    });

    test('Test: Get trade details successfully', () async {
      final url = Uri.parse('http://localhost:8080/trades/$tradeId');
      final params = {
        'user_id': '0',
      };
      final uri = Uri.parse(url.toString()).replace(queryParameters: params);
      final response = await get(uri);
      expect(response.statusCode, 200);
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // for (String key in jsonResponse.keys) {
      //   print(key);
      //   print(jsonResponse[key]);
      // }
      final productName = jsonResponse['product_name'];
      expect(productName, '木の椅子');
    });

    test('Test: Get trade details failed', () async {
      final url = Uri.parse('http://localhost:8080/trades/-1');
      final params = {
        'user_id': '0',
      };
      final uri = Uri.parse(url.toString()).replace(queryParameters: params);
      final response = await get(uri);
      expect(response.statusCode, 404);
    });

    test('Test: Update approval status', () async {
      final url = Uri.parse('http://localhost:8080/trades/$tradeId');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'is_giver': true,
      };
      final jsonBody = json.encode(body);
      var response = await put(url, headers: headers, body: jsonBody);
      expect(response.statusCode, 200);
    });

    test('Test: Update isChecked status', () async {
      final url = Uri.parse('http://localhost:8080/trades/$tradeId/isChecked');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'is_checked': true,
      };
      final jsonBody = json.encode(body);
      var response = await put(url, headers: headers, body: jsonBody);
      expect(response.statusCode, 200);
    });
  });
}
