import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../lib/Domain/constants.dart';

void main() {
  group('WebSocket Server Communication Tests', () {
    late WebSocketChannel channel;
    final url = Uri.parse('ws://127.0.0.1:8080/chat/ws/1');

    setUp(() {
      channel = WebSocketChannel.connect(url);
    });

    tearDown(() {
      channel.sink.close();
    });

    test('Test: send message', () {
      var jsonMessage = jsonEncode({
        'sender_id': '1',
        'receiver_id': '2',
        'message': 'Hello World!!',
        'send_date_time': DateTime.now().toIso8601String(),
      });
      channel.sink.add(jsonMessage);
    });
  });

  group('Chat Log Test', (){
    test('Test: Get chat log successfully 1->2', () async {
      final url = Uri.parse('http://$ipAddress:8080/chat/1/2');
      final response = await get(url);
      expect(response.statusCode, 200);
    });

    test('Test: Get chat log successfully 2->1', () async {
      final url = Uri.parse('http://$ipAddress:8080/chat/2/1');
      final response = await get(url);
      expect(response.statusCode, 200);
    });

    test('Test: Get chat log failed', () async {
      final url = Uri.parse('http://$ipAddress:8080/chat/1/1');
      final response = await get(url);
      expect(response.statusCode, 400);
    });

    test('Test: Get chat log null', () async {
      final url = Uri.parse('http://$ipAddress:8080/chat/10/20');
      final response = await get(url);
      expect(response.statusCode, 200);
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      expect(jsonResponse['chats'].length,0);
    });
  });
}
