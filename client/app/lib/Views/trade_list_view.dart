import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/Domain/trade.dart';
import 'package:app/Views/components/trade_cell.dart';

class TradeListView extends HookConsumerWidget {
  const TradeListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Container(
      color: const Color(0xffffffff),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(),
              TradeCell(
                trade: trade,
                isCompleted: true,
              ),
              TradeCell(
                trade: trade,
                isCompleted: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
