import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/trade.dart';
import 'todo_cell.dart';

class TodoListView extends HookConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final trade = Trade(
      tradeId: 0,
      receiverName: 'ibuibukiki',
      productName: "ガラス天板のローテーブル",
      image: null,
      tradePlace: '高田馬場駅',
      tradeDate: DateTime(2024, 7, 16, 12, 0),
      furnitureId: 0,
      giverId: 0,
      receiverId: 1,
      isChecked: false,
      giverApproval: false,
      receiverApproval: false,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        backgroundColor: const Color(0xffffffff),
        automaticallyImplyLeading: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'やることリスト',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: screenSize.height - 80,
        color: const Color(0xffffffff),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, top: 40,right: 16),
          child: Column(
            children: [
              const Divider(),
              TodoCell(trade:trade,tradeStatus: 0),
              TodoCell(trade:trade,tradeStatus: 1),
              TodoCell(trade:trade,tradeStatus: 2),
            ],
          ),
        ),
      ),
    );
  }
}
