import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/furniture.dart';
import '../../Usecases/provider.dart';
import '../../Usecases/trade_api.dart';
import '../common/furniture_cell.dart';
import 'todo_list_view.dart';
import 'favorite_list_view.dart';

class FurnitureListView extends HookConsumerWidget {
  final List<Furniture> furnitureList;
  final ValueNotifier<int> selectedView;
  const FurnitureListView({
    required this.furnitureList,
    required this.selectedView,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final userId = ref.read(userIdProvider);

    final ValueNotifier<List<Row>> favoriteList = useState([]);
    final ValueNotifier<List<Row>> favoriteAllList = useState([]);
    final ValueNotifier<List<Row>> latestList = useState([]);
    useEffect(() {
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
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        elevation: 8,
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
                  backgroundColor: const Color(0xffffffff),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: SizedBox(
                  width: screenSize.width - 136,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_camera_outlined),
                      SizedBox(width: 8),
                      Text('部屋にあった家具を探す'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // 取引リストの取得
                  final futureResult = getTradeList(userId);
                  futureResult.then((result) {
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodoListView(tradeList: result),
                      ),
                    );
                  }).catchError((error) {
                    return Center(
                      child: Text('error: $error'),
                    );
                  });
                },
                icon: const Icon(
                  size: 24,
                  Icons.done_outline,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: const Color(0xffeeeeee),
        child: SingleChildScrollView(
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
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      color: const Color(0xffffffff),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // ヘッダー
                          SizedBox(
                            height: 48,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  ' いいねした商品',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
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
                                            Text('すべて見る'),
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
                            272
                    : 52 +
                        ((screenSize.width - 40) / 3 + 8) *
                            latestList.value.length,
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(children: latestList.value),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
