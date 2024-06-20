import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test: API is running', () async {
    var url = Uri.parse('http://localhost:8080/ok');
    var response = await http.get(url);
    expect(response.statusCode, 200);
  });

  group('User Account Test', () {
    final userName = DateTime.now().toString();
    test('Test: User registered successfully', () async {
      var url = Uri.parse('http://localhost:8080/sign_up');
      var headers = {'Content-Type': 'application/json'};
      var requestBody = jsonEncode({
        'username': userName,
        'password': 'password',
        'area': 0,
      });
      var response = await http.post(url, headers: headers, body: requestBody);
      expect(response.statusCode, 200);
    });
    test('Test: User registered failed', () async {
      var url = Uri.parse('http://localhost:8080/sign_up');
      var headers = {'Content-Type': 'application/json'};
      var requestBody = jsonEncode({
        'username': userName,
        'password': 'password',
        'area': 0,
      });
      var response = await http.post(url, headers: headers, body: requestBody);
      expect(response.statusCode, 500);
    });
    test('Test: User login successfully', () async {
      var url = Uri.parse('http://localhost:8080/login');
      var headers = {'Content-Type': 'application/json'};
      var requestBody = jsonEncode({
        'username': userName,
        'password': 'password',
      });
      var response = await http.post(url, headers: headers, body: requestBody);
      expect(response.statusCode, 200);
      var jsonResponse = jsonDecode(response.body);
      var userId = jsonResponse['userId'];
      expect(userId,isA<int>()); // int型がt型が返ってくることを確認
    });
    test('Test: User login failed', () async {
      var url = Uri.parse('http://localhost:8080/login');
      var headers = {'Content-Type': 'application/json'};
      var requestBody = jsonEncode({
        'username': userName,
        'password': 'not_password',
      });
      var response = await http.post(url, headers: headers, body: requestBody);
      expect(response.statusCode, 401);
    });
  });
}
