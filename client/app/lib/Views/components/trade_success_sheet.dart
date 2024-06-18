import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TradeSuccessSheet extends HookConsumerWidget {
  const TradeSuccessSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 64),
              // なんかイラスト
              Container(
                height: 200,
                width: 200,
                color: const Color(0xffe1e1e1),
              ),
              const SizedBox(height: 24),
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
              Container(
                padding: const EdgeInsets.all(16),
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
                      side: const BorderSide(color: Color(0xff424242)),
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
                        fontSize: 14,
                        color: Color(0xff424242),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ],
      ),
    );
  }
}
