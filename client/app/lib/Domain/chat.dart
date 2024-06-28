import 'dart:async';
import 'dart:convert';
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
  final _controller = StreamController<List<Message>>.broadcast();

  Chat(this.url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
    channel.stream.listen((dataList) {
      print(dataList);
      List<Message> messages = convertMessages(dataList);
      _controller.add(messages);
    }, onError: (error) {
      print(error);
    });
  }

  List<Message> convertMessages(dynamic dataList) {
    List<Message> messageList = [];
    for (dynamic data in dataList) {
      final message = Message(
        senderId: data['sender_id'],
        receiverId: data['receiver_id'],
        message: data['message'],
        sendDateTime: data['send_date_time'],
      );
      messageList.add(message);
    }
    return messageList;
  }

  Stream<List<Message>> get getMessages => _controller.stream;

  void sendMessage(Message message) {
    var jsonMessage = jsonEncode({
      'sender_id': message.senderId.toString(),
      'receiver_id': message.receiverId.toString(),
      'message': message.message,
      'send_date_time': message.sendDateTime.toIso8601String(),
    });
    _controller.add([message]);
    channel.sink.add(jsonMessage);
  }

  void dispose() {
    _controller.close();
    channel.sink.close();
  }
}
