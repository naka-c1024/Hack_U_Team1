import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
      expect(userId, isA<int>()); // int型がt型が返ってくることを確認
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
      final request = Request(
        'GET',
        Uri.parse('http://localhost:8080/furniture'),
      )..headers.addAll({
          'Content-Type': 'application/json',
        });
      final requestBody = {
        'user_id': 0,
        'keyword': '',
      };
      request.body = jsonEncode(requestBody);
      StreamedResponse response = await request.send();
      expect(response.statusCode, 200);
      final jsonResponse = jsonDecode(await response.stream.bytesToString());
      final furnitureList = jsonResponse['furniture'];
      expect(furnitureList.length,isNonZero);
    });

    test('Test: Search furniture by keyword', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost:8080/furniture'),
      )..headers.addAll({
          'Content-Type': 'application/json',
        });
      final requestBody = {
        'user_id': 0,
        'keyword': 'ソファ',
      };
      request.body = jsonEncode(requestBody);
      StreamedResponse response = await request.send();
      expect(response.statusCode, 200);
      final jsonResponse = jsonDecode(await response.stream.bytesToString());
      final furnitureList = jsonResponse['furniture'];
      final furniture = furnitureList[0];
      expect(furniture['product_name'], 'ソファ');
      furnitureId = furniture['furniture_id'];
    });

    test('Test: Get furniture detailed successfully', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost:8080/furniture/$furnitureId'),
      )..headers.addAll({
          'Content-Type': 'application/json',
        });
      final requestBody = {
        'user_id': 0,
      };
      request.body = jsonEncode(requestBody);
      StreamedResponse response = await request.send();
      expect(response.statusCode, 200);
      final jsonResponse = jsonDecode(await response.stream.bytesToString());
      final productName = jsonResponse['product_name'];
      expect(productName, 'ソファ');
    });

    test('Test: Get furniture detailed failed', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost:8080/furniture/0'),
      )..headers.addAll({
          'Content-Type': 'application/json',
        });
      final requestBody = {
        'user_id': 0,
      };
      request.body = jsonEncode(requestBody);
      StreamedResponse response = await request.send();
      expect(response.statusCode, 404);
    });
  });
}
