import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/furniture.dart';
import '../../Domain/theme_color.dart';
import '../../Usecases/provider.dart';
import '../common/error_dialog.dart';
import '../common/furniture_cell.dart';
import 'todo_list_view.dart';
import 'favorite_list_view.dart';

class FurnitureListView extends HookConsumerWidget {
  final ValueNotifier<int> selectedView;
  const FurnitureListView({
    required this.selectedView,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    final furnitureState = ref.watch(furnitureListProvider);

    // 画面を更新
    Future<void> reloadFurnitureList() {
      // ignore: unused_result
      ref.refresh(furnitureListProvider);
      return ref.read(furnitureListProvider.future);
    }

    // 画面を移動した時に自動で更新
    useEffect(() {
      Future.microtask(() => {reloadFurnitureList()});
      return null;
    }, []);

    final ValueNotifier<List<Row>> favoriteList = useState([]);
    final ValueNotifier<List<Row>> favoriteAllList = useState([]);
    final ValueNotifier<List<Row>> latestList = useState([]);

    // 取得したデータを元に表示する家具リストを作成
    void createCellList(List<Furniture> furnitureList) {
      List<Widget> row = [];
      List<Widget> favoriteRow = [];
      for (Furniture furniture in furnitureList.reversed) {
        // 全ての商品をリストに入れる
        row.add(FurnitureCell(furniture: furniture));
        // 3個貯まったら追加
        if (row.length == 3) {
          latestList.value.add(Row(children: row));
          row = [];
        }
        // いいねした商品だけリストに入れる
        if (furniture.isFavorite) {
          favoriteRow.add(FurnitureCell(furniture: furniture));
          // 3個貯まったら追加
          if (favoriteRow.length == 3) {
            // 二行だけ表示
            if (favoriteList.value.length < 2) {
              favoriteList.value.add(Row(children: favoriteRow));
            }
            // 全部のリストも作成
            favoriteAllList.value.add(Row(children: favoriteRow));
            favoriteRow = [];
          }
        }
      }
      // あまりを追加
      if (row.isNotEmpty) {
        latestList.value.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: row,
          ),
        );
      }
      if (favoriteRow.isNotEmpty) {
        // 二行だけ表示
        if (favoriteList.value.length < 2) {
          favoriteList.value.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: favoriteRow,
            ),
          );
        }
        // 全部のリストも作成
        favoriteAllList.value.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: favoriteRow,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        automaticallyImplyLeading: false,
        title: Container(
          height: 56,
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  selectedView.value = 1;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.keyGreen,
                  padding: const EdgeInsets.only(right: 8),
                ),
                child: SizedBox(
                  width: screenSize.width - 96,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/icon.png',
                        color: const Color(0xffffffff),
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        '部屋にあった家具を探す',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // やることリストへ
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TodoListView(),
                    ),
                  );
                },
                icon: Image.asset(
                  'assets/images/todo_icon.png',
                  height: 24,
                  width: 24,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: const Color(0xffeeeeee),
        // 下に引っ張った時に更新
        child: RefreshIndicator(
          color: ThemeColors.keyGreen,
          onRefresh: () => reloadFurnitureList(),
          // 家具リストの取得
          child: furnitureState.when(
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: ThemeColors.keyGreen,
              ),
            ),
            error: (error, __) => errorDialog(context,error.toString()),
            skipLoadingOnRefresh: false,
            data: (data) {
              favoriteList.value = [];
              favoriteAllList.value = [];
              latestList.value = [];
              createCellList(data);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    favoriteList.value.isEmpty
                        ? const SizedBox()
                        : const SizedBox(height: 8),
                    // いいねした商品
                    favoriteList.value.isEmpty
                        ? const SizedBox()
                        : Container(
                            height: 52 +
                                ((screenSize.width - 40) / 3 + 8) *
                                    favoriteList.value.length,
                            width: screenSize.width,
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            color: const Color(0xffffffff),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // ヘッダー
                                SizedBox(
                                  height: 48,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        ' いいねした商品',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: ThemeColors.black,
                                        ),
                                      ),
                                      favoriteList.value.length <
                                              favoriteAllList.value.length
                                          ? TextButton(
                                              onPressed: () {
                                                // いいねした商品をすべて見るページへ
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FavoriteListView(
                                                      favoriteAllList:
                                                          favoriteAllList.value,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Row(
                                                children: [
                                                  Text(
                                                    'すべて見る',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      color: Color(0xff575757),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Icon(
                                                    size: 16,
                                                    Icons.arrow_forward_ios,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                                Column(children: favoriteList.value),
                              ],
                            ),
                          ),
                    const SizedBox(height: 8),
                    // 最新の商品
                    Container(
                      height: latestList.value.length < 5
                          ? favoriteList.value.isEmpty
                              ? screenSize.height -
                                  ((screenSize.width - 40) / 3 + 8) *
                                      favoriteList.value.length -
                                  192
                              : screenSize.height -
                                  ((screenSize.width - 40) / 3 + 8) *
                                      favoriteList.value.length -
                                  240
                          : 52 +
                              ((screenSize.width - 40) / 3 + 8) *
                                  latestList.value.length,
                      width: screenSize.width,
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      color: const Color(0xffffffff),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ヘッダー
                          Container(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: const Text(
                              ' 最新の商品',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ThemeColors.black,
                              ),
                            ),
                          ),
                          Column(children: latestList.value),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
