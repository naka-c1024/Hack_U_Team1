import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
      channel.sink.close();
    });
  });
}
