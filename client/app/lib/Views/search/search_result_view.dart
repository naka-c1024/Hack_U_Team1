import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/furniture.dart';
import '../../Domain/theme_color.dart';
import '../../Usecases/provider.dart';
import '../common/furniture_cell.dart';
import 'area_filter_menu.dart';
import 'color_filter_menu.dart';
import 'size_filter_menu.dart';

class SearchResultView extends HookConsumerWidget {
  final String searchWord;
  final bool isSearchPicture;
  const SearchResultView({
    required this.searchWord,
    required this.isSearchPicture,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    final searchResultState = ref.watch(searchResultProvider.notifier).state;
    final searchResult = ref.watch(searchResultProvider);

    final reason = ref.watch(reasonProvider);

    // const reason =
    //     'この部屋は自然光が豊富で木の家具との調和がとれたナチュラルな雰囲気があるので、ベージュ色の家具がこの穏やかな雰囲気をさらに引き立てます。';

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

    final isNoResponse = useState(false);
    final ValueNotifier<List<Widget>> resultList = useState([
      // デフォルトでインジケータを表示
      const Center(
        child: CircularProgressIndicator(color: ThemeColors.keyGreen),
      ),
    ]);
    useEffect(() {
      List<Widget> row = [];
      if (searchResult == null ){
        isNoResponse.value = true;
        return null;
      } else {
        isNoResponse.value = false;
      }
      for (Furniture furniture in searchResult) {
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
      resultList.value.removeAt(0);
      return null;
    }, [searchResultState]);

    useEffect(() {
      Future.delayed(const Duration(seconds: 3), () {
        if (isNoResponse.value) {
          resultList.value = [
            const Center(
              child: Text(
                '読み込みに失敗しました。\nもう一度条件を入力して検索してくだい。',
                textAlign: TextAlign.center,
                style:TextStyle(color:ThemeColors.textGray1)
              ),
            ),
          ];
        }
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: Container(
        color: const Color(0xffffffff),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  collapsedHeight: isSearchPicture
                      ? 128 + ((reason ?? '').length / 30 + 1) * 24
                      : 128,
                  expandedHeight: 56 + ((reason ?? '').length / 30 + 1) * 24,
                  automaticallyImplyLeading: false,
                  backgroundColor: const Color(0xffffffff),
                  floating: true,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: ClipRect(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: 1.0,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(0);
                                    ref.read(colorListProvider.notifier).state =
                                        [];
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: ThemeColors.black,
                                  ),
                                ),
                                // 検索した条件を表示
                                isSearchPicture
                                    ? Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/icon.png',
                                            height: 30,
                                            width: 30,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            searchWord,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: ThemeColors.black,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        height: 32,
                                        width: screenSize.width - 80,
                                        padding: const EdgeInsets.only(left: 8),
                                        color: ThemeColors.bgGray1,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.search,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              searchWord,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff4b4b4b),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                            Container(
                              height: isSearchPicture && reason != null
                                  ? 80 + (reason.length / 30 + 1) * 24
                                  : 80,
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              color: const Color(0xffffffff),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  isSearchPicture && reason != null
                                      ? Flexible(
                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                8, 0, 8, 12),
                                            width: screenSize.width,
                                            child: Text(
                                              reason,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: ThemeColors.black,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            18, 8, 16, 8),
                                        child: Image.asset(
                                          'assets/images/filter_icon.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      // 受け渡しエリアで絞るボタン
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            isSelectingArea.value =
                                                !isSelectingArea.value;
                                            isSelectingColor.value = false;
                                            isSelectingSize.value = false;
                                          },
                                          child: Ink(
                                            height: 32,
                                            width: 136,
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 4, 8, 4),
                                            decoration: BoxDecoration(
                                              color: isSelectingArea.value ||
                                                      selectedArea
                                                          .value.isNotEmpty
                                                  ? ThemeColors.bgGray1
                                                  : const Color(0xffffffff),
                                              border: Border.all(
                                                  color: ThemeColors.bgGray1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                                      : Icons
                                                          .keyboard_arrow_down,
                                                  color:
                                                      const Color(0xff575757),
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
                                            isSelectingColor.value =
                                                !isSelectingColor.value;
                                            isSelectingArea.value = false;
                                            isSelectingSize.value = false;
                                          },
                                          child: Ink(
                                            height: 32,
                                            width: 64,
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 4, 8, 4),
                                            decoration: BoxDecoration(
                                              color: isSelectingColor.value ||
                                                      selectedColorList
                                                          .isNotEmpty
                                                  ? ThemeColors.bgGray1
                                                  : const Color(0xffffffff),
                                              border: Border.all(
                                                  color: ThemeColors.bgGray1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                                      : Icons
                                                          .keyboard_arrow_down,
                                                  color:
                                                      const Color(0xff575757),
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
                                            isSelectingSize.value =
                                                !isSelectingSize.value;
                                            isSelectingArea.value = false;
                                            isSelectingColor.value = false;
                                          },
                                          child: Ink(
                                            height: 32,
                                            width: 96,
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 4, 8, 4),
                                            decoration: BoxDecoration(
                                              color: isSelectingSize.value ||
                                                      (maxWidth.text != '' ||
                                                          maxDepth.text != '' ||
                                                          maxHeight.text !=
                                                              '' ||
                                                          minWidth.text != '' ||
                                                          minDepth.text != '' ||
                                                          minHeight.text != '')
                                                  ? ThemeColors.bgGray1
                                                  : const Color(0xffffffff),
                                              border: Border.all(
                                                  color: ThemeColors.bgGray1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                                      : Icons
                                                          .keyboard_arrow_down,
                                                  color:
                                                      const Color(0xff575757),
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
                                        height: 40,
                                        width: 40,
                                        child: Transform.scale(
                                          scale: 1.2,
                                          child: Checkbox(
                                            value: isSoldOnly.value,
                                            onChanged: (value) {
                                              isSoldOnly.value = value ?? false;
                                            },
                                            activeColor: ThemeColors.keyGreen,
                                            side: const BorderSide(
                                              width: 1.5,
                                              color: ThemeColors.bgGray1,
                                            ),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: screenSize.width,
                    padding: const EdgeInsets.all(8),
                    color: const Color(0xffffffff),
                    child: resultList.value.isEmpty
                        ? const Center(
                            child: Text('検索結果：0件'),
                          )
                        : Column(children: resultList.value),
                  ),
                ),
              ],
            ),
            // エリア選択メニュー
            isSelectingArea.value
                ? Container(
                    height: 496,
                    width: screenSize.width,
                    color: const Color(0xffffffff),
                    child: Column(
                      children: [
                        const Divider(),
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
                                    color: ThemeColors.bgGray1,
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
                                backgroundColor: ThemeColors.keyGreen,
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
                    height: 456,
                    width: screenSize.width,
                    color: const Color(0xffffffff),
                    child: Column(
                      children: [
                        const Divider(),
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
                                ref.read(colorListProvider.notifier).state = [];
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffffffff),
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: ThemeColors.bgGray1,
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
                                backgroundColor: ThemeColors.keyGreen,
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
                        const Divider(),
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
                                    color: ThemeColors.bgGray1,
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
                                backgroundColor: ThemeColors.keyGreen,
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
      ),
    );
  }
}
