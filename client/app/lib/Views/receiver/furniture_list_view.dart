import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/constants.dart';
import '../common/furniture_cell.dart';
import 'favorite_list_view.dart';
import 'todo_list_view.dart';

class FurnitureListView extends HookConsumerWidget {
  const FurnitureListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    const prefecturesIndex = 12;
    
    // いいねした商品を表示するためのリスト
    final favoriteList = [
      Row(
        children: [
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
        ],
      ),
      Row(
        children: [
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
        ],
      ),
    ];

    // 最新の商品を表示するためのリスト
    final latestList = [
      Row(
        children: [
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: true),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
        ],
      ),
      Row(
        children: [
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: true),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
        ],
      ),
      Row(
        children: [
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: true),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: true),
        ],
      ),
      Row(
        children: [
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: true),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: true),
        ],
      ),
      Row(
        children: [
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: true),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
        ],
      ),
      Row(
        children: [
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: true),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
          FurnitureCell(
              prefecture: prefectures[prefecturesIndex], isSaled: false),
        ],
      ),
    ];

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
                onPressed: () {},
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
                  // やることリストをすべて見るページへ
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TodoListView(),
                    ),
                  );
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
              const SizedBox(height: 8),
              // いいねした商品
              Container(
                height: 52 +
                    ((screenSize.width - 40) / 3 + 8) * favoriteList.length,
                padding: const EdgeInsets.only(left: 8, right: 8),
                color: const Color(0xffffffff),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // ヘッダー
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          ' いいねした商品',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // いいねした商品をすべて見るページへ
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FavoriteListView(
                                  favoriteAllList: latestList,
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
                        ),
                      ],
                    ),
                    Column(children: favoriteList),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // 最新の商品
              Container(
                height:
                    52 + ((screenSize.width - 40) / 3 + 8) * latestList.length,
                padding: const EdgeInsets.only(left: 8, right: 8),
                color: const Color(0xffffffff),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ヘッダー
                    Container(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(
                        ' ${prefectures[prefecturesIndex]}の最新の商品',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(children: latestList),
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
