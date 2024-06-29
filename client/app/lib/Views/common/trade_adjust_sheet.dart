import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import '../../Domain/furniture.dart';
import '../../Domain/theme_color.dart';
import '../../Usecases/provider.dart';
import '../../Usecases/trade_api.dart';
import 'error_dialog.dart';
import 'trade_order_sheet.dart';

class TradeAdjustSheet extends HookConsumerWidget {
  final Furniture furniture;
  const TradeAdjustSheet({super.key, required this.furniture});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final userId = ref.read(userIdProvider);

    final isSelectingDate = useState(false);
    final ValueNotifier<DateTime?> tradeDate = useState(null);

    final isSelectingTime = useState(false);
    final ValueNotifier<DateTime?> tradeTime = useState(null);

    final startDate =
        furniture.startDate ?? DateTime.now().add(const Duration(days: 1));
    final endDate =
        furniture.endDate ?? DateTime.now().add(const Duration(days: 365));

    late final hoursWheel = WheelPickerController(
      itemCount: 24,
      initialIndex: DateTime.now().hour % 24,
    );
    late final minutesWheel = WheelPickerController(
      itemCount: 60,
      initialIndex: DateTime.now().minute,
      mounts: [hoursWheel],
    );

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
          const Divider(color:Color(0xffababab)),
          Container(
            height: 560,
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SingleChildScrollView(
              reverse: isSelectingDate.value || isSelectingTime.value,
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
                          color: ThemeColors.bgGray1,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Center(
                            child: Image.memory(furniture.image!),
                          ),
                        ),
                      ),
                      Text(furniture.productName),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '受け渡し場所',
                    style: TextStyle(
                      color: Color(0xff4b4b4b),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(color:Color(0xffababab)),
                  const SizedBox(height: 4),
                  // 受け渡し場所
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 96,
                        child: Text(
                          '場所',
                          style: TextStyle(
                            color: ThemeColors.textGray1,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            furniture.tradePlace,
                            style: const TextStyle(
                              color: ThemeColors.textGray1,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              'assets/images/trade_map.png',
                              width: 256,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '受け渡し日の指定',
                    style: TextStyle(
                      color: Color(0xff4b4b4b),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(color:Color(0xffababab)),
                  const SizedBox(height: 4),
                  // 受け渡し期間の説明
                  Text(
                    (furniture.startDate == null && furniture.endDate == null)
                        ? '${DateFormat('yyyy年M月d日(E)', 'ja').format(DateTime.now().add(const Duration(days: 1)))} 〜 の間で指定してください。'
                        : furniture.startDate == null
                            ? '${DateFormat('yyyy年M月d日(E)', 'ja').format(DateTime.now().add(const Duration(days: 1)))}  〜 ${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.endDate!)} の間で指定してください。'
                            : furniture.endDate == null
                                ? '${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.startDate!)} 〜 の間で指定してください。'
                                : '${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.startDate!)} 〜 ${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.endDate!)} の間で指定してください。',
                    style: const TextStyle(
                      color: ThemeColors.textGray1,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 日時指定
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '日時',
                        style: TextStyle(
                          color: ThemeColors.textGray1,
                          fontSize: 14,
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
                          backgroundColor: const Color(0xffffffff),
                          foregroundColor: ThemeColors.textGray1,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                              color: isSelectingDate.value
                                  ? ThemeColors.keyGreen
                                  : ThemeColors.bgGray1,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: ThemeColors.bgGray1),
                          ),
                          child: Text(
                            tradeDate.value == null
                                ? '日付'
                                : DateFormat('yyyy年M月d日(E)', 'ja')
                                    .format(tradeDate.value!),
                            style: const TextStyle(
                              color: ThemeColors.textGray1,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // 時間選択ボタン
                      ElevatedButton(
                        onPressed: () {
                          isSelectingTime.value = !isSelectingTime.value;
                          tradeTime.value ??= DateTime.now();
                          if (isSelectingDate.value) {
                            isSelectingDate.value = false;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffffffff),
                          foregroundColor: ThemeColors.textGray1,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                              color: isSelectingTime.value
                                  ? ThemeColors.keyGreen
                                  : ThemeColors.bgGray1,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: ThemeColors.bgGray1),
                          ),
                          child: Text(
                            tradeTime.value == null
                                ? '時間'
                                : DateFormat('HH:mm').format(tradeTime.value!),
                            style: const TextStyle(
                              color: ThemeColors.textGray1,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  //　日付選択画面
                  isSelectingDate.value
                      ? Container(
                          height: 320,
                          padding: const EdgeInsets.only(bottom: 8),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            border: Border.all(color: ThemeColors.bgGray1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: CalendarDatePicker2(
                            config: CalendarDatePicker2Config(
                              firstDate: startDate,
                              lastDate: endDate,
                              centerAlignModePicker: true,
                              selectedDayHighlightColor:
                                  ThemeColors.keyGreen,
                              selectedDayTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffffffff),
                              ),
                              todayTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ThemeColors.keyGreen,
                              ),
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
                              dayBuilder: (
                                  {required date,
                                  decoration,
                                  isDisabled,
                                  isSelected,
                                  isToday,
                                  textStyle}) {
                                Widget? dayWidget;
                                if ((date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) &&
                                    (date.isBefore(endDate) || date.isAtSameMomentAs(endDate))) {
                                  dayWidget = Container(
                                    decoration: decoration,
                                    child: Center(
                                      child: Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: const BoxDecoration(
                                              color: Color(0x2075d000),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Text(
                                            MaterialLocalizations.of(context)
                                                .formatDecimal(date.day),
                                            style: textStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return dayWidget;
                              },
                            ),
                            value: [tradeDate.value],
                            onValueChanged: (dates) => {
                              tradeDate.value = dates[0],
                            },
                          ),
                        )
                      : const SizedBox(),
                  // 時間選択画面
                  isSelectingTime.value
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            border: Border.all(color: ThemeColors.bgGray1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: screenSize.width - 80,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xffe6f5d0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WheelPicker(
                                    builder: (BuildContext context, int index) {
                                      return Text(
                                        "$index".padLeft(2, '0'),
                                        style: const TextStyle(fontSize: 20),
                                      );
                                    },
                                    controller: hoursWheel,
                                    looping: false,
                                    selectedIndexColor: const Color(0xff4b4b4b),
                                    style: const WheelPickerStyle(
                                      size: 160,
                                      squeeze: 1.25,
                                      diameterRatio: .8,
                                      surroundingOpacity: .25,
                                      magnification: 1.2,
                                      itemExtent: 40,
                                    ),
                                    onIndexChanged: (index) {
                                      final originalDateTime =
                                          tradeTime.value ?? DateTime.now();
                                      final selectedDataTime = DateTime(
                                          originalDateTime.year,
                                          originalDateTime.month,
                                          originalDateTime.day,
                                          index,
                                          originalDateTime.minute);
                                      tradeTime.value = selectedDataTime;
                                    },
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      " : ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  WheelPicker(
                                    builder: (BuildContext context, int index) {
                                      return Text(
                                        "$index".padLeft(2, '0'),
                                        style: const TextStyle(fontSize: 20),
                                      );
                                    },
                                    controller: minutesWheel,
                                    enableTap: true,
                                    selectedIndexColor: const Color(0xff4b4b4b),
                                    style: const WheelPickerStyle(
                                      size: 160,
                                      squeeze: 1.25,
                                      diameterRatio: .8,
                                      surroundingOpacity: .25,
                                      magnification: 1.2,
                                      itemExtent: 40,
                                    ),
                                    onIndexChanged: (index) {
                                      final originalDateTime =
                                          tradeTime.value ?? DateTime.now();
                                      final selectedDataTime = DateTime(
                                          originalDateTime.year,
                                          originalDateTime.month,
                                          originalDateTime.day,
                                          originalDateTime.hour,
                                          index);
                                      tradeTime.value = selectedDataTime;
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          const Divider(color:Color(0xffababab)),
          // 取引依頼ボタン
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                if (tradeDate.value != null && tradeTime.value != null) {
                  DateTime tradeDateTime = DateTime(
                    tradeDate.value!.year,
                    tradeDate.value!.month,
                    tradeDate.value!.day,
                    tradeTime.value!.hour,
                    tradeTime.value!.minute,
                    tradeTime.value!.second,
                    tradeTime.value!.millisecond,
                    tradeTime.value!.microsecond,
                  );
                  final futureResult = requestTrade(
                      furniture.furnitureId!, userId, tradeDateTime);
                  futureResult.then((result) {
                    return showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: screenSize.height - 64,
                          child: const TradeOrderSheet(),
                        );
                      },
                    );
                  }).catchError((error) {
                    return showErrorDialog(context, error.toString());
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    (tradeDate.value == null || tradeTime.value == null)
                        ? ThemeColors.bgGray2
                        : ThemeColors.keyGreen,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
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
                    fontSize: 16,
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
