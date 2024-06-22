import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../Domain/trade.dart';
import '../../../Usecases/provider.dart';
import '../../../Usecases/furniture_api.dart';
import '../../common/trade_detail_view.dart';

class TradeCell extends HookConsumerWidget {
  final Trade trade;
  final bool isTrading;
  const TradeCell({
    required this.trade,
    required this.isTrading,
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
              final futureResult = getFurnitureDetails(userId, trade.furnitureId);
              futureResult.then((result) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TradeDetailView(
                      trade: trade,
                      furniture: result,
                      tradeStatus: isTrading ? 2 : 1,
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
                        isTrading ? '受け渡しは完了しましたか？' : '取引依頼を承認しますか？',
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
