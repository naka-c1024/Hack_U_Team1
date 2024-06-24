import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/furniture.dart';
import '../../Usecases/provider.dart';
import '../common/furniture_cell.dart';
import 'area_filter_menu.dart';
import 'color_filter_menu.dart';
import 'size_filter_menu.dart';

class SearchResultView extends HookConsumerWidget {
  final String searchWord;
  final List<Furniture> furnitureList;
  const SearchResultView({
    required this.searchWord,
    required this.furnitureList,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    // メニューウィンドウの表示を管理
    final isSelectingArea = useState(false);
    final isSelectingColor = useState(false);
    final isSelectingSize = useState(false);

    // 検索条件を保持
    final selectedArea = useState<List<int>>([]);
    final selectedColorList = ref.watch(colorListProvider);
    final maxWidth = useTextEditingController(text: '');
    final maxDepth = useTextEditingController(text: '');
    final maxHeight = useTextEditingController(text: '');
    final minWidth = useTextEditingController(text: '');
    final minDepth = useTextEditingController(text: '');
    final minHeight = useTextEditingController(text: '');
    final isSoldOnly = useState(false);

    final ValueNotifier<List<Row>> resultList = useState([]);
    useEffect(() {
      List<Widget> row = [];
      for (Furniture furniture in furnitureList) {
        // 全ての商品をリストに入れる
        row.add(FurnitureCell(furniture: furniture));
        // 3個貯まったら追加
        if (row.length == 3) {
          resultList.value.add(Row(children: row));
          row = [];
        }
      }
      // あまりを追加
      if (row.isNotEmpty) {
        resultList.value.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: row,
          ),
        );
      }
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(0);
                ref.read(colorListProvider.notifier).state = [];
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff131313),
              ),
            ),
            // 検索した条件を表示
            Row(
              children: [
                Image.asset(
                  'assets/images/icon.png',
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 12),
                Text(
                  searchWord == '' ? '検索結果' : searchWord,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff131313),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 88,
            padding: const EdgeInsets.only(left: 8, right: 8),
            color: const Color(0xffffffff),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                        color: Color(0xff4b4b4b),
                      ),
                    ),
                    // 受け渡しエリアで絞るボタン
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          isSelectingArea.value = !isSelectingArea.value;
                          isSelectingColor.value = false;
                          isSelectingSize.value = false;
                        },
                        child: Ink(
                          height: 32,
                          width: 136,
                          padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
                          decoration: BoxDecoration(
                            color: isSelectingArea.value ||
                                    selectedArea.value.isNotEmpty
                                ? const Color(0xffd9d9d9)
                                : const Color(0xffffffff),
                            border: Border.all(color: const Color(0xffd9d9d9)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                '受け渡しエリア',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff4b4b4b),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                isSelectingArea.value
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: const Color(0xff575757),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 色で絞るボタン
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          isSelectingColor.value = !isSelectingColor.value;
                          isSelectingArea.value = false;
                          isSelectingSize.value = false;
                        },
                        child: Ink(
                          height: 32,
                          width: 64,
                          padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
                          decoration: BoxDecoration(
                            color: isSelectingColor.value ||
                                    selectedColorList.isNotEmpty
                                ? const Color(0xffd9d9d9)
                                : const Color(0xffffffff),
                            border: Border.all(color: const Color(0xffd9d9d9)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                '色',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff4b4b4b),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                isSelectingColor.value
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: const Color(0xff575757),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // サイズで絞るボタン
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          isSelectingSize.value = !isSelectingSize.value;
                          isSelectingArea.value = false;
                          isSelectingColor.value = false;
                        },
                        child: Ink(
                          height: 32,
                          width: 96,
                          padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
                          decoration: BoxDecoration(
                            color: isSelectingSize.value ||
                                    (maxWidth.text != '' ||
                                        maxDepth.text != '' ||
                                        maxHeight.text != '' ||
                                        minWidth.text != '' ||
                                        minDepth.text != '' ||
                                        minHeight.text != '')
                                ? const Color(0xffd9d9d9)
                                : const Color(0xffffffff),
                            border: Border.all(color: const Color(0xffd9d9d9)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'サイズ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff4b4b4b),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                isSelectingSize.value
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: const Color(0xff575757),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 48),
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: Checkbox(
                        value: isSoldOnly.value,
                        onChanged: (value) {
                          isSoldOnly.value = value ?? false;
                        },
                        activeColor: Theme.of(context).primaryColor,
                        side: const BorderSide(
                          width: 1.5,
                          color: Color(0xffd9d9d9),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '販売中の商品のみを表示',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff4b4b4b),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children: [
              // 検索結果
              Container(
                height: screenSize.height - 204,
                width: screenSize.width,
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                color: const Color(0xffffffff),
                child: SingleChildScrollView(
                  child: resultList.value.isEmpty
                      ? const Center(
                          child: Text('検索結果：0件'),
                        )
                      : Column(children: resultList.value),
                ),
              ),
              // エリア選択メニュー
              isSelectingArea.value
                  ? Container(
                      height: 488,
                      width: screenSize.width,
                      color: const Color(0xffffffff),
                      child: Column(
                        children: [
                          Container(
                            height: 416,
                            width: screenSize.width,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: AreaFilterMenu(selectedArea: selectedArea),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // クリアボタン
                              ElevatedButton(
                                onPressed: () {
                                  isSelectingArea.value = false;
                                  selectedArea.value = [];
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffffffff),
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Color(0xffd9d9d9),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Container(
                                  height: 40,
                                  width: 64,
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'クリア',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff4b4b4b),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // 決定ボタン
                              ElevatedButton(
                                onPressed: () {
                                  isSelectingArea.value = false;
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Container(
                                  height: 40,
                                  width: 64,
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '決定する',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              // 色選択メニュー
              isSelectingColor.value
                  ? Container(
                      height: 448,
                      width: screenSize.width,
                      color: const Color(0xffffffff),
                      child: Column(
                        children: [
                          Container(
                            height: 376,
                            width: screenSize.width,
                            color: const Color(0xffffffff),
                            padding: const EdgeInsets.all(16),
                            child: const ColorFilterMenu(),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // クリアボタン
                              ElevatedButton(
                                onPressed: () {
                                  isSelectingColor.value = false;
                                  ref.read(colorListProvider.notifier).state =
                                      [];
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffffffff),
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Color(0xffd9d9d9),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Container(
                                  height: 40,
                                  width: 64,
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'クリア',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff4b4b4b),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // 決定ボタン
                              ElevatedButton(
                                onPressed: () {
                                  isSelectingColor.value = false;
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Container(
                                  height: 40,
                                  width: 64,
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '決定する',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              // サイズ選択メニュー
              isSelectingSize.value
                  ? Container(
                      height: 336,
                      width: screenSize.width,
                      color: const Color(0xffffffff),
                      child: Column(
                        children: [
                          Container(
                            height: 256,
                            width: screenSize.width,
                            padding: const EdgeInsets.all(16),
                            color: const Color(0xffffffff),
                            child: SizeFilterMenu(
                              maxWidth: maxWidth,
                              maxDepth: maxDepth,
                              maxHeight: maxHeight,
                              minWidth: minWidth,
                              minDepth: minDepth,
                              minHeight: minHeight,
                            ),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // クリアボタン
                              ElevatedButton(
                                onPressed: () {
                                  isSelectingSize.value = false;
                                  maxWidth.text = '';
                                  maxDepth.text = '';
                                  maxHeight.text = '';
                                  minWidth.text = '';
                                  minDepth.text = '';
                                  minHeight.text = '';
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffffffff),
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Color(0xffd9d9d9),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Container(
                                  height: 40,
                                  width: 64,
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'クリア',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff4b4b4b),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // 決定ボタン
                              ElevatedButton(
                                onPressed: () {
                                  isSelectingSize.value = false;
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Container(
                                  height: 40,
                                  width: 64,
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '決定する',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
