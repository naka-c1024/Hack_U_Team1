import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/theme_color.dart';
import '../../Domain/chat.dart';
import '../../Usecases/provider.dart';
import 'chat_cell.dart';
import 'error_dialog.dart';

class ChatView extends HookConsumerWidget {
  final String userName;
  const ChatView({
    required this.userName,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final userId = ref.watch(userIdProvider);
    final chatLog = ref.watch(chatLogProvider(2));

    final chatCellList = useState<List<Widget>>([]);
    void createChatCellList(List<Message> chatLog) {
      chatCellList.value = [];
      for (int i = 0; i < chatLog.length; i++) {
        final message = chatLog[i];
        if (message.senderId == userId) {
          chatCellList.value.add(MyMessageCell(message: message));
        } else {
          chatCellList.value.add(YourMessageCell(message: message));
        }
        if (i < chatLog.length - 1 &&
            chatLog[i].senderId != chatLog[i].receiverId) {
          chatCellList.value.add(const SizedBox(height: 24));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '$userName さんとのチャット',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ThemeColors.black,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: screenSize.height - 80,
        width: screenSize.width,
        color: const Color(0xffffffff),
        child: Column(
          children: [
            const Divider(color: ThemeColors.bgGray1),
            chatLog.when(
              data: (chatLog) {
                createChatCellList(chatLog);
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: chatCellList.value),
                );
              },
              loading: () => const Center(
              child: CircularProgressIndicator(
                color: ThemeColors.keyGreen,
              ),
            ),
              error: (error, __) => errorDialog(context,error.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
