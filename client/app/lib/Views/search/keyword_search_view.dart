import 'package:app/Domain/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Usecases/provider.dart';
import '../../Usecases/furniture_api.dart';
import '../common/cateogory_cell.dart';
import 'search_result_view.dart';

class KeywordSearchView extends HookConsumerWidget {
  const KeywordSearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    final searchWordController = useTextEditingController(text: '');
    final focus = useFocusNode();
    final isFocused = useState(false);
    final userId = ref.read(userIdProvider);
    final categoryIndex = ref.read(categoryProvider);

    useEffect(() {
      void onFocusChanged() {
        isFocused.value = focus.hasFocus;
      }

      focus.addListener(onFocusChanged);
      return () => focus.removeListener(onFocusChanged);
    }, [focus]);

    final future = useMemoized(SharedPreferences.getInstance);
    final snapshot = useFuture(future, initialData: null);
    final ValueNotifier<List<Widget>> searchLogList = useState([]);
    final ValueNotifier<List<String>> searchLogTextList = useState([]);

    // 検索履歴を読み込んで表示
    useEffect(() {
      final preferences = snapshot.data;
      if (preferences == null) {
        return null;
      }
      searchLogTextList.value = preferences.getStringList('searchLog') ?? [];
      for (int i = searchLogTextList.value.length - 1; i >= 0; i--) {
        searchLogList.value.add(
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                searchWordController.text = searchLogTextList.value[i];
              },
              child: Ink(
                width: screenSize.width - 32,
                padding: const EdgeInsets.only(top: 4, left: 4, bottom: 4),
                child: Text(
                  searchLogTextList.value[i],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
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
    }, [snapshot.data]);

    // 検索履歴を保存
    void saveSearchLog(String searchWord) {
      final preferences = snapshot.data;
      if (preferences == null) {
        return;
      }
      final List<String> searchLogTextList =
          preferences.getStringList('searchLog') ?? [];
      if (searchLogTextList.length == 5) {
        searchLogTextList.removeAt(0);
      }
      searchLogTextList.add(searchWord);
      preferences.setStringList('searchLog', searchLogTextList);
    }

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
                            searchWordController.text = '';
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
                      controller: searchWordController,
                      onSubmitted: (String value) {
                        FocusScope.of(context).unfocus();
                        if (value != '' &&
                            !searchLogTextList.value.contains(value)) {
                          saveSearchLog(value);
                        }
                        if (categoryIndex == -1) {
                          searchFurnitureList(ref, userId, null, value);
                        } else {
                          searchFurnitureList(
                              ref, userId, categoryIndex, value);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultView(
                              searchWord: searchWordController.text == '' &&
                                      categoryIndex == -1
                                  ? '検索結果'
                                  : categoryIndex == -1
                                      ? searchWordController.text
                                      : categorys[categoryIndex],
                              isSearchPicture: false,
                            ),
                          ),
                        );
                        ref.read(categoryProvider.notifier).state = -1;
                      },
                      textInputAction: TextInputAction.search,
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
