import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/theme_color.dart';
import '../../Usecases/provider.dart';
import '../../Domain/chat.dart';
import 'chat_cell.dart';
import 'error_dialog.dart';

class ChatView extends HookConsumerWidget {
  final String userName;
  final int yourId;
  final List<Message> chatLog;
  const ChatView({
    required this.userName,
    required this.yourId,
    required this.chatLog,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    final userId = ref.watch(userIdProvider);
    final chat = ref.watch(chatProvider);
    final messages = ref.watch(messagesProvider);

    final controller = useTextEditingController(text: '');

    final chatCellList = useState<List<Widget>>([]);
    void createChatCellList(List<Message> chatLog) {
      chatCellList.value = [];
      var num = chatLog.length;
      if (chatLog.length > 1){
        num = num-1;
      }
      for (int i = 0; i < num; i++) {
        final message = chatLog[i];
        if (message.senderId == userId) {
          chatCellList.value.add(MyMessageCell(message: message));
        } else {
          chatCellList.value.add(YourMessageCell(message: message));
        }
        chatCellList.value.add(const SizedBox(height: 8));
      }
    }

    useEffect(() {
      createChatCellList(chatLog);
      return null;
    }, []);

    final newChatCellList = useState<List<Widget>>([]);
    void addNewMessage(List<Message> messageList) {
      for (int i = 0; i < messageList.length; i++) {
        final message = messageList[i];
        if (message.senderId == userId) {
          newChatCellList.value.add(MyMessageCell(message: message));
        } else {
          newChatCellList.value.add(YourMessageCell(message: message));
        }
        newChatCellList.value.add(const SizedBox(height: 8));
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop(0);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ThemeColors.black,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '$userNameとのチャット',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ThemeColors.black,
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: Container(
          height: screenSize.height - 80,
          width: screenSize.width,
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: ThemeColors.bgGray1)),
            color: Color(0xffffffff),
          ),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                // チャットのログを表示
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(children: chatCellList.value),
                ),
                // 新しくやりとりしたメッセージを表示
                messages.when(
                  data: (messages) {
                    addNewMessage(messages);
                    return Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(children: newChatCellList.value),
                    );
                  },
                  loading: () => const SizedBox(),
                  error: (error, __) => errorDialog(context, error.toString()),
                ),
                const SizedBox(height: 16),
                Container(
                  width: screenSize.width,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: ThemeColors.bgGray1)),
                    color: Color(0xffffffff),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 28,
                        width: 28,
                        child: Image.asset(
                          'assets/images/album_icon.png',
                          scale: 1,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: screenSize.width - 80,
                        padding: const EdgeInsets.only(left: 16),
                        color: ThemeColors.bgGray3,
                        child: TextField(
                          onSubmitted: (value) {
                            controller.text = value;
                            final newMessage = Message(
                              senderId: userId,
                              receiverId: yourId,
                              message: controller.text,
                              sendDateTime: DateTime.now(),
                            );
                            chat.sendMessage(newMessage);
                            controller.text = '';
                          },
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'チャットを送る',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: ThemeColors.textGray1,
                            ),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: ThemeColors.black,
                          ),
                          textInputAction: TextInputAction.send,
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          minLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
