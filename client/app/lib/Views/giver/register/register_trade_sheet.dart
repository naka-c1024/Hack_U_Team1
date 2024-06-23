import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import '../../../Domain/furniture.dart';
import '../../../Usecases/provider.dart';
import '../../../Usecases/furniture_api.dart';

class RegisterTradeSheet extends HookConsumerWidget {
  final Furniture furniture;
  const RegisterTradeSheet({
    required this.furniture,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final userId = ref.read(userIdProvider);

    final tradePlace = useTextEditingController(text: '');

    final ValueNotifier<DateTime?> tradeStartDate = useState(null);
    final ValueNotifier<DateTime?> tradeEndDate = useState(null);

    final ValueNotifier<List<DateTime?>> selectedRange = useState([null]);

    useEffect(() {
      if (selectedRange.value.isNotEmpty) {
        tradeStartDate.value = selectedRange.value.first;
        tradeEndDate.value = selectedRange.value.last;
      }
      return null;
    }, [selectedRange.value]);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
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
                  '受け渡し希望を入力',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 64),
              ],
            ),
            // ページの進捗表示
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff000000),
                  ),
                ),
                Container(
                  height: 2,
                  width: 24,
                  color: const Color(0xff000000),
                ),
                Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff000000),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            Container(
              height: 560,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      '受け渡し場所',
                      style: TextStyle(
                        color: Color(0xff6a6a6a),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 受け渡し場所入力欄
                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: const Color(0xffd9d9d9),
                        ),
                      ),
                      child: TextField(
                        controller: tradePlace,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xffd9d9d9),
                          ),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '受け渡し期間',
                      style: TextStyle(
                        color: Color(0xff6a6a6a),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 開始日指定
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '開始',
                          style: TextStyle(
                            color: Color(0xff636363),
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          tradeStartDate.value == null
                              ? '未指定'
                              : DateFormat('yyyy年M月d日（E）', 'ja')
                                  .format(tradeStartDate.value!),
                          style: const TextStyle(
                            color: Color(0xff636363),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 終了日指定
                    Row(
                      children: [
                        const Text(
                          '終了',
                          style: TextStyle(
                            color: Color(0xff636363),
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        // 日付選択ボタン
                        Text(
                          tradeEndDate.value == null
                              ? '未指定'
                              : DateFormat('yyyy年M月d日（E）', 'ja')
                                  .format(tradeEndDate.value!),
                          style: const TextStyle(
                            color: Color(0xff636363),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    const SizedBox(height: 16),
                    //　日付選択画面
                    Container(
                      height: 296,
                      padding: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffd9d9d9)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: CalendarDatePicker2(
                        config: CalendarDatePicker2Config(
                          firstDate: DateTime.now(),
                          calendarType: CalendarDatePicker2Type.range,
                          centerAlignModePicker: true,
                          weekdayLabels: ['日', '月', '火', '水', '木', '金', '土'],
                          disableModePicker: true,
                        ),
                        value: selectedRange.value,
                        onValueChanged: (dates) => {
                          selectedRange.value = dates,
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            const Divider(),
            // 出品ボタン
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  // 受け渡し場所さえ入力されていればok
                  if (tradePlace.text != '') {
                    furniture.updateTradeParams(
                      tradePlace: tradePlace.text,
                      startDate: tradeStartDate.value,
                      endDate: tradeEndDate.value,
                    );
                    ref.read(categoryProvider.notifier).state = -1;
                    ref.read(colorProvider.notifier).state = -1;
                    ref.read(conditionProvider.notifier).state = -1;
                    ref.read(heightProvider.notifier).state = null;
                    ref.read(widthProvider.notifier).state = null;
                    ref.read(depthProvider.notifier).state = null;
                    final futureResult = registerFurniture(userId, furniture);
                    futureResult.then((result) {
                      Navigator.of(context).pop(0);
                      Navigator.of(context).pop(0);
                    }).catchError((error) {
                      print('error: $error');
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: tradePlace.text == ''
                      ? const Color(0xffffffff)
                      : const Color(0xff424242),
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
                  child: Text(
                    '出品する',
                    style: TextStyle(
                      fontSize: 14,
                      color: tradePlace.text == ''
                          ? const Color(0xff9e9e9e)
                          : const Color(0xffffffff),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
