import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../Domain/trade.dart';
import '../../common/trade_approve_sheet.dart';

class TradeDetailView extends HookConsumerWidget {
  final Trade trade;
  final bool isCompleted;
  const TradeDetailView({
    required this.trade,
    required this.isCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

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
              isCompleted
                  ? '受け渡しは完了しましたか？'
                  : '${trade.receiverName} さんに商品を譲りますか？',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            isCompleted
                // 完了ボタン
                ? ElevatedButton(
                    onPressed: () {
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
                              isCompleted: true,
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
                  )
                // 譲るキャンセルボタン
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
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
                        isCompleted ? FontWeight.normal : FontWeight.bold,
                    color: isCompleted
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
                onTap: () {},
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
