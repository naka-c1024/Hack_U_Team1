import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/theme_color.dart';
import '../../Usecases/provider.dart';

class TradeOrderSheet extends HookConsumerWidget {
  const TradeOrderSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    Future<void> reloadTradeList() {
      // ignore: unused_result
      ref.refresh(tradeListProvider);
      return ref.read(tradeListProvider.future);
    }

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  // 取引リストを更新
                  reloadTradeList();
                  // もとの画面に戻る
                  Navigator.of(context).pop(0);
                  Navigator.of(context).pop(0);
                  Navigator.of(context).pop(0);
                },
                icon: const Icon(Icons.close),
              ),
              const Text(
                '取引確認',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 64),
            ],
          ),
          const Divider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              // イラスト
              SizedBox(
                width: 280,
                child:Image.asset('assets/images/trade_order.png')
              ),
              const Text(
                '取引をお願いしました！',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff5c5c5c),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '返信を待ちましょう。',
                style: TextStyle(
                  color: Color(0xff5c5c5c),
                ),
              ),
              const SizedBox(height: 64),
              // 戻るボタン
              Container(
                padding: const EdgeInsets.only(left: 16, bottom: 4, right: 16),
                child: ElevatedButton(
                  onPressed: () {
                    // もとの画面に戻る
                    Navigator.of(context).pop(0);
                    Navigator.of(context).pop(0);
                    Navigator.of(context).pop(0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffffffff),
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: ThemeColors.keyGreen,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Container(
                    height: 48,
                    width: screenSize.width - 48,
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    alignment: Alignment.center,
                    child: const Text(
                      '戻る',
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeColors.keyGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // チャットボタン
              // ElevatedButton(
              //   onPressed: () {},
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: const Color(0xffffffff),
              //     padding: EdgeInsets.zero,
              //     minimumSize: Size.zero,
              //     elevation: 0,
              //     shape: RoundedRectangleBorder(
              //       side: const BorderSide(
              //         color: ThemeColors.lineGray1,
              //       ),
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //   ),
              //   child: Container(
              //     height: 48,
              //     width: (screenSize.width - 48),
              //     margin: const EdgeInsets.only(left: 8, right: 8),
              //     alignment: Alignment.center,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Image.asset(
              //           'assets/images/chat_icon.png',
              //           width: 24,
              //           color: ThemeColors.lineGray2,
              //         ),
              //         const SizedBox(width: 16),
              //         const Padding(
              //           padding: EdgeInsets.only(bottom: 4),
              //           child: Text(
              //             'チャットする',
              //             style: TextStyle(
              //               fontSize: 12,
              //               color: ThemeColors.lineGray2,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }
}
