import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/trade.dart';
import '../../../Usecases/provider.dart';
import '../../../Usecases/furniture_api.dart';
import 'trade_detail_view.dart';

class TodoCell extends HookConsumerWidget {
  final Trade trade;
  final int tradeStatus;
  const TodoCell({
    required this.trade,
    required this.tradeStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.read(userIdProvider);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // 取引承認ページへ
              final futureResult =
                  getFurnitureDetails(userId, trade.furnitureId);
              futureResult.then((result) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TradeDetailView(
                      trade: trade,
                      furniture: result,
                      tradeStatus: tradeStatus,
                    ),
                  ),
                );
              }).catchError((error) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Center(
                      child: Text('error: $error'),
                    ),
                  ),
                );
              });
            },
            child: Ink(
              height: 88,
              color: const Color(0xffffffff),
              child: Row(
                children: [
                  Container(
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      color: const Color(0xffd9d9d9),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Center(
                        child: Image.asset(trade.imagePath),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        tradeStatus == 0
                            ? '取引依頼の返事を待っています。'
                            : tradeStatus == 1
                                ? '取引依頼が届きました。'
                                : '取引は完了しましたか？',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tradeStatus == 0
                            ? '返答を待ちましょう。'
                            : tradeStatus == 1
                                ? '取引を受けるか、返答しましょう。'
                                : '取引を完了しましょう。',
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
