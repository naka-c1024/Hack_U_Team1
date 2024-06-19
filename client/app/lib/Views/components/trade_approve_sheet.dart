import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TradeApproveSheet extends HookConsumerWidget {
  final bool isCompleted;
  const TradeApproveSheet({
    required this.isCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 64),
        // なんかイラスト
        Container(
          height: 200,
          width: 200,
          color: const Color(0xffe1e1e1),
        ),
        const SizedBox(height: 24),
        Text(
          isCompleted ? 'おつかれさまでした！' : '取引成立！',
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xffffffff),
            fontWeight: FontWeight.bold,
          ),
        ),
        isCompleted
            ? const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '相手も取引を完了すれば\nこの商品は譲渡済みに移行します。',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xffffffff),
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              // もとの画面に戻る
              Navigator.of(context).pop(0);
              Navigator.of(context).pop(0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffffffff)),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: Container(
              height: 32,
              width: 120,
              margin: const EdgeInsets.only(left: 8, right: 8),
              alignment: Alignment.center,
              child: const Text(
                '閉じる',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xffffffff),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
