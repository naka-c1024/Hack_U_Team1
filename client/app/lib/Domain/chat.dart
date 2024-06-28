import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class Message {
  final int senderId;
  final int receiverId;
  final String message;
  final DateTime sendDateTime;
  
  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.sendDateTime,
  });
}

class Chat {
  final String url;
  late final WebSocketChannel channel;

  Chat(this.url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
  }

  Stream<List<Message>> getMessages() {
    return channel.stream.map((dataList) {
      List<Message> messageList = [];
      for (dynamic data in dataList){
        final message = Message(
          senderId: data['sender_id'],
          receiverId: data['receiver_id'],
          message: data['message'],
          sendDateTime: data['send_date_tieme'],
        );
        messageList.add(message);
      }
      return messageList;
    });
  }
}
