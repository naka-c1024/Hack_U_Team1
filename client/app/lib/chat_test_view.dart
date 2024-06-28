import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Usecases/provider.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatLog = ref.watch(chatLogProvider(2));
    // final messages = ref.watch(messagesProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: chatLog.when(
        data: (initialMessages) {//messages.when(
          //data: (liveMessages) {
            final allMessages = initialMessages;
            return ListView.builder(
              itemCount: allMessages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(allMessages[index].message),
                );
              },
            );
          // },
          // loading: () => CircularProgressIndicator(),
          // error: (error, stack) => Text('Error: $error'),
        },
        loading: () => CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }
}
