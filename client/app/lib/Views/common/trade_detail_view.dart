import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Domain/trade.dart';
import '../../Domain/furniture.dart';
import '../../Usecases/trade_api.dart';
import '../../Usecases/provider.dart';
import 'trade_approve_sheet.dart';
import 'furniture_detail_view.dart';

class TradeDetailView extends HookConsumerWidget {
  final Trade trade;
  final Furniture furniture;
  final int tradeStatus;
  const TradeDetailView({
    required this.trade,
    required this.furniture,
    required this.tradeStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final userId = ref.read(userIdProvider);
    final future = useMemoized(SharedPreferences.getInstance);
    final snapshot = useFuture(future, initialData: null);

    // 譲渡を承認した取引のtradeIdを保存
    void saveTradingIdList(int tradeId) {
      final preferences = snapshot.data;
      if (preferences == null) {
        return;
      }
      final List<String> tradingIdList =
          preferences.getStringList('tradingIdList') ?? [];
      tradingIdList.add(tradeId.toString());
      preferences.setStringList('tradingIdList', tradingIdList);
    }

    // 譲渡を完了したらtradeIdを削除
    void deleteTradingIdList(int tradeId) {
      final preferences = snapshot.data;
      if (preferences == null) {
        return;
      }
      final List<String> tradingIdList =
          preferences.getStringList('tradingIdList') ?? [];
      if (tradingIdList.contains(tradeId.toString())) {
        tradingIdList.remove(tradeId.toString());
      }
      preferences.setStringList('tradingIdList', tradingIdList);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        backgroundColor: const Color(0xffffffff),
        automaticallyImplyLeading: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '取引画面',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
        color: const Color(0xffffffff),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tradeStatus == 0
                  ? '取引依頼の返事を待っています。'
                  : tradeStatus == 1
                      ? '${trade.receiverName} さんに商品を譲りますか？'
                      : '受け渡しは完了しましたか？',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            tradeStatus == 0
                ? const SizedBox()
                : tradeStatus == 1
                    // 譲るキャンセルボタン
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              final futureResult =
                                  approveTrade(trade.tradeId, true);
                              futureResult.then((result) {
                                return showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: screenSize.height,
                                      width: screenSize.width,
                                      color: const Color(0x4b000000),
                                      child: const TradeApproveSheet(
                                        isCompleted: true,
                                      ),
                                    );
                                  },
                                );
                              }).catchError((error) {
                                return Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Center(
                                      child: Text('error: $error'),
                                    ),
                                  ),
                                );
                              });
                              saveTradingIdList(trade.tradeId);
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: screenSize.height,
                                    width: screenSize.width,
                                    color: const Color(0x4b000000),
                                    child: const TradeApproveSheet(
                                      isCompleted: false,
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff424242),
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Color(0xff424242),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Container(
                              height: 48,
                              width: (screenSize.width - 80) / 2,
                              margin: const EdgeInsets.only(left: 8, right: 8),
                              alignment: Alignment.center,
                              child: const Text(
                                '譲る',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffffffff),
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Color(0xff424242),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Container(
                              height: 48,
                              width: (screenSize.width - 80) / 2,
                              margin: const EdgeInsets.only(left: 8, right: 8),
                              alignment: Alignment.center,
                              child: const Text(
                                'キャンセル',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff424242),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ) // 完了ボタン
                    // 取引完了ボタン
                    : ElevatedButton(
                        onPressed: () {
                          if (trade.receiverId == userId) {
                            final futureResult =
                                approveTrade(trade.tradeId, false);
                            futureResult.then((result) {
                              return showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: screenSize.height,
                                    width: screenSize.width,
                                    color: const Color(0x4b000000),
                                    child: const TradeApproveSheet(
                                      isCompleted: true,
                                    ),
                                  );
                                },
                              );
                            }).catchError((error) {
                              return Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Center(
                                    child: Text('error: $error'),
                                  ),
                                ),
                              );
                            });
                          } else {
                            deleteTradingIdList(trade.tradeId);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff424242),
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Color(0xff424242),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Container(
                          height: 48,
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          alignment: Alignment.center,
                          child: const Text(
                            '完了した',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

            const SizedBox(height: 24),
            const Text(
              '受け渡し',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff424242),
              ),
            ),
            const Divider(),
            // 場所
            Row(
              children: [
                const Text(
                  '場所',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff424242),
                  ),
                ),
                const SizedBox(width: 80),
                Text(
                  trade.tradePlace,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff424242),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 日時
            Row(
              children: [
                const Text(
                  '日時',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff424242),
                  ),
                ),
                const SizedBox(width: 80),
                Text(
                  DateFormat('yyyy年M月d日 （E）  h:mm', 'ja')
                      .format(trade.tradeDate),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        tradeStatus == 2 ? FontWeight.normal : FontWeight.bold,
                    color: tradeStatus == 2
                        ? const Color(0xff424242)
                        : const Color(0xff000000),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              '希望者情報',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff424242),
              ),
            ),
            const Divider(),
            // 希望者情報
            Row(
              children: [
                const SizedBox(width: 16),
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xffd9d9d9),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 24),
                Text(
                  trade.receiverName,
                  style: const TextStyle(
                    color: Color(0xff636363),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              '商品情報',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff424242),
              ),
            ),
            const Divider(),
            // 商品情報
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // 家具の詳細ページへ
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FurnitureDetailView(
                        furniture: furniture,
                        isMyProduct: true,
                        isHiddenButton: true,
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
                        height: 88,
                        width: 88,
                        decoration: BoxDecoration(
                          color: const Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Center(
                            child: Image.memory(trade.image),
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
                            trade.productName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 4, right: 8),
                                child: Icon(
                                  Icons.favorite_outline_outlined,
                                  color: Color(0xff636363),
                                ),
                              ),
                              Text(
                                'いいね 8件',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff636363),
                                ),
                              ),
                            ],
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
        ),
      ),
    );
  }
}
