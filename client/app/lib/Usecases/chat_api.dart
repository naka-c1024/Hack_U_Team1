import 'dart:convert';
import 'package:http/http.dart';

import '../Domain/chat.dart';
import '../Domain/constants.dart';

Future<List<Message>> getChatLog(int senderId, int receiverId) async {
  try {
    final url = Uri.parse('http://$ipAddress:8080/chat/$senderId/$receiverId');
    final response = await get(url);
    final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      final dataList = jsonResponse['chats'];
      final List<Message> messageList = [];
      for (dynamic data in dataList) {
        print(data);
        final message = Message(
          senderId: data['sender_id'],
          receiverId: data['receiver_id'],
          message: data['message'],
          sendDateTime: data['send_date_time'] == null
              ? DateTime.now()
              : DateTime.parse(data['send_date_time']),
        );
        messageList.add(message);
      }
      return messageList;
    } else {
      final msg = jsonResponse['detail'];
      throw Exception('Failed to get furniture list: $msg');
    }
  } catch (e) {
    throw Exception('Undefined Error: $e');
  }
}
