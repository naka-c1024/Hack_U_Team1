import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/Views/components/cateogry_cell.dart';

class KeywordSearchView extends HookConsumerWidget {
  const KeywordSearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final focus = FocusNode();
    final isFocused = useState(false);

    void onFocusChanged() {
      isFocused.value = true;
    }

    useEffect(() {
      focus.addListener(onFocusChanged);
      return null;
    }, []);

    final searchLogTextList = [
      'ローテーブル  ガラス',
      'ローテーブル  かっこいい',
      '観葉植物',
      'みどり',
      'サボテン',
    ];

    final ValueNotifier<List<Widget>> searchLogList = useState([]);

    useEffect(() {
      for (int i = 0; i < searchLogTextList.length; i++) {
        searchLogList.value.add(
          Container(
            margin: const EdgeInsets.only(top: 4, left: 4, bottom: 4),
            child: Text(
              searchLogTextList[i],
              style: const TextStyle(fontSize: 14),
            ),
          ),
        );
        searchLogList.value.add(
          const Divider(),
        );
      }
      searchLogList.value.add(
        const SizedBox(height: 24),
      );
      return null;
    }, []);

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      color: const Color(0xffffffff),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // 検索バー
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isFocused.value
                      ? IconButton(
                          onPressed: () {
                            isFocused.value = false;
                            FocusScope.of(context).unfocus();
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                        )
                      : const SizedBox(),
                  Container(
                    height: 40,
                    width: isFocused.value
                        ? screenSize.width - 80
                        : screenSize.width - 32,
                    alignment: Alignment.center,
                    color: const Color(0xffd9d9d9),
                    child: TextField(
                      focusNode: focus,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'キーワードで探す',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 4, bottom: 4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            isFocused.value
                ? const SizedBox()
                // カテゴリメニュー
                : const Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'カテゴリ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryCell(categoryIndex: 0),
                          CategoryCell(categoryIndex: 1),
                          CategoryCell(categoryIndex: 2),
                          CategoryCell(categoryIndex: 3),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryCell(categoryIndex: 4),
                          CategoryCell(categoryIndex: 5),
                          CategoryCell(categoryIndex: 6),
                          CategoryCell(categoryIndex: 7),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryCell(categoryIndex: 8),
                          CategoryCell(categoryIndex: 9),
                          CategoryCell(categoryIndex: 10),
                          CategoryCell(categoryIndex: 11),
                        ],
                      ),
                      SizedBox(height: 24),
                    ],
                  ),

            const Text(
              '検索履歴',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: searchLogList.value,
            ),
          ],
        ),
      ),
    );
  }
}
