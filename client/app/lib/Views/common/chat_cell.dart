import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/theme_color.dart';
import '../../Domain/chat.dart';

String formatSendDateTime(DateTime sendDateTime){
  DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(Duration(days: 1));
  if (sendDateTime.year == yesterday.year && sendDateTime.month == yesterday.month && sendDateTime.day == yesterday.day) {
    return '昨日';
  } else {
    // 時刻を "H:mm" 形式でフォーマット
    return DateFormat('H:mm').format(sendDateTime);
  }
}

class YourMessageCell extends HookConsumerWidget {
  final Message message;
  const YourMessageCell({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.asset(
            'assets/images/user_icon_2.png',
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            width: screenSize.width - 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: ThemeColors.lineGray1),
            ),
            child: Text(
              message.message,
              style: const TextStyle(
                fontSize: 14,
                color: ThemeColors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            SizedBox(height: 16 + 24 * (message.message.length/20+1) - 24),
            Text(
              formatSendDateTime(message.sendDateTime),
              style: const TextStyle(
                fontSize: 9,
                color: ThemeColors.textGray1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MyMessageCell extends HookConsumerWidget {
  final Message message;
  const MyMessageCell({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          children: [
            SizedBox(height: 16 + 24 * (message.message.length/20+1) - 24),
            Text(
              formatSendDateTime(message.sendDateTime),
              style: const TextStyle(
                fontSize: 9,
                color: ThemeColors.textGray1,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            width: screenSize.width - 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: ThemeColors.keyGreen),
            ),
            child: Text(
              message.message,
              style: const TextStyle(
                fontSize: 14,
                color: ThemeColors.black,
              ),
            ),
          ),
        )
      ],
    );
  }
}
