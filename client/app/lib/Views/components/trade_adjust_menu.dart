import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import 'package:app/Domain/furniture.dart';

class TradeAdjustMenu extends HookConsumerWidget {
  final Furniture furniture;
  const TradeAdjustMenu({super.key, required this.furniture});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    final isSelectingDate = useState(false);
    final ValueNotifier<DateTime?> tradeDate = useState(null);

    final isSelectingTime = useState(false);
    final ValueNotifier<DateTime?> tradeTime = useState(null);

    final startDate =
        furniture.startDate ?? DateTime.now().add(const Duration(days: 1));
    final endDate =
        furniture.endDate ?? DateTime.now().add(const Duration(days: 365));

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
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
          Container(
            height: 584,
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        margin: const EdgeInsets.fromLTRB(0, 16, 24, 16),
                        decoration: BoxDecoration(
                          color: const Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Text(furniture.productName),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '受け渡し場所',
                    style: TextStyle(
                      color: Color(0xff6a6a6a),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(),
                  const SizedBox(height: 4),
                  // 受け渡し場所
                  Row(
                    children: [
                      const SizedBox(
                        width: 96,
                        child: Text(
                          '場所',
                          style: TextStyle(
                            color: Color(0xff636363),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        furniture.tradePlace,
                        style: const TextStyle(
                          color: Color(0xff636363),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '受け渡し日の指定',
                    style: TextStyle(
                      color: Color(0xff6a6a6a),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(),
                  const SizedBox(height: 4),
                  // 受け渡し期間の説明
                  Text(
                    (furniture.startDate == null && furniture.endDate == null)
                        ? '${DateFormat('yyyy年M月d日(E)', 'ja').format(DateTime.now().add(const Duration(days: 1)))} 〜 の期間で指定してください。'
                        : furniture.startDate == null
                            ? '${DateFormat('yyyy年M月d日(E)', 'ja').format(DateTime.now().add(const Duration(days: 1)))}  〜 ${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.endDate!)} の期間で指定してください。'
                            : furniture.endDate == null
                                ? '${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.startDate!)} 〜 の期間で指定してください。'
                                : '${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.startDate!)} 〜 ${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.endDate!)} の期間で指定してください。',
                    style: const TextStyle(
                      color: Color(0xff636363),
                      fontSize: 12,
                    ),
                  ),
                  // 日時指定
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '日時',
                        style: TextStyle(
                          color: Color(0xff636363),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 48),
                      // 日付選択ボタン
                      ElevatedButton(
                        onPressed: () {
                          isSelectingDate.value = !isSelectingDate.value;
                          if (isSelectingTime.value) {
                            isSelectingTime.value = false;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelectingDate.value
                              ? const Color(0xffd9d9d9)
                              : const Color(0xffffffff),
                          foregroundColor: const Color(0xff636363),
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Container(
                          height: 24,
                          padding:
                              const EdgeInsets.only(left: 8, top: 2, right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: const Color(0xffd9d9d9)),
                          ),
                          child: Text(
                            tradeDate.value == null
                                ? '日付'
                                : DateFormat('yyyy年M月d日(E)', 'ja')
                                    .format(tradeDate.value!),
                            style: const TextStyle(
                              color: Color(0xff636363),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // 時間選択ボタン
                      ElevatedButton(
                        onPressed: () {
                          isSelectingTime.value = !isSelectingTime.value;
                          if (isSelectingDate.value) {
                            isSelectingDate.value = false;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelectingTime.value
                              ? const Color(0xffd9d9d9)
                              : const Color(0xffffffff),
                          foregroundColor: const Color(0xff636363),
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Container(
                          height: 24,
                          padding:
                              const EdgeInsets.only(left: 8, top: 2, right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: const Color(0xffd9d9d9)),
                          ),
                          child: Text(
                            tradeTime.value == null
                                ? '時間'
                                : DateFormat('hh:mm', 'ja')
                                    .format(tradeTime.value!),
                            style: const TextStyle(
                              color: Color(0xff636363),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  isSelectingDate.value
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffd9d9d9)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: CalendarDatePicker2(
                            config: CalendarDatePicker2Config(
                              firstDate: startDate,
                              lastDate: endDate,
                              centerAlignModePicker: true,
                              weekdayLabels: [
                                '日',
                                '月',
                                '火',
                                '水',
                                '木',
                                '金',
                                '土'
                              ],
                              disableModePicker: true,
                            ),
                            value: [tradeDate.value],
                            onValueChanged: (dates) => {
                              tradeDate.value = dates[0],
                            },
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          const Spacer(),
          const Divider(),
          // 取引依頼ボタン
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffffffff),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Color(0xff9e9e9e)),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Container(
                height: 48,
                width: screenSize.width - 48,
                margin: const EdgeInsets.only(left: 8, right: 8),
                alignment: Alignment.center,
                child: const Text(
                  '取引をお願いする',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff9e9e9e),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
