import 'package:app/Views/trade_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/Domain/trade.dart';

class TradeCell extends HookConsumerWidget {
  final Trade trade;
  final bool isCompleted;
  const TradeCell({
    required this.trade,
    required this.isCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // 取引承認ページへ
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TradeDetailView(
                    trade: trade,
                    isCompleted: isCompleted,
                  ),
                ),
              );
            },
            child: Ink(
              height: 88,
              color: const Color(0xffffffff),
              child: Row(
                children: [
                  Container(
                    // TODO: ここに写真が入る
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      color: const Color(0xffd9d9d9),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        trade.productName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isCompleted ? '受け渡しは完了しましたか？' : '取引依頼を承認しますか？',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff636363),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                    color: Color(0xff575757),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
