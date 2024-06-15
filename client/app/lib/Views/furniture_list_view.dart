import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FurnitureListView extends HookConsumerWidget {
  const FurnitureListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    // 家具の写真
    final furnitureCell = ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Container(
        height: (screenSize.width - 40) / 3,
        width: (screenSize.width - 40) / 3,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xffd9d9d9),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            //TODO: ここに写真が入る
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 24,
                  width: 72,
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  decoration: BoxDecoration(
                    color: const Color(0x2b666666),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    '東京都',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );

    // いいねした商品を表示するためのリスト
    final favoriteList = [
      furnitureCell,
      furnitureCell,
    ];

    // 最新の商品を表示するためのリスト
    final latestList = [
      Row(
        children: [
          furnitureCell,
          furnitureCell,
          furnitureCell,
        ],
      ),
      Row(
        children: [
          furnitureCell,
          furnitureCell,
          furnitureCell,
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        backgroundColor: const Color(0xffffffff),
        title: Container(
          height: 60,
          padding: const EdgeInsets.only(top: 4, bottom: 16),
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
                onPressed: () {},
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
                height: 196,
                padding: const EdgeInsets.only(left: 8, top: 4, right: 8),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
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
                    Row(children: favoriteList),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // 最新の商品
              Container(
                height: 800,
                padding: const EdgeInsets.only(left: 8, top: 4, right: 8),
                color: const Color(0xffffffff),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // ヘッダー
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          ' 東京都の最新の商品',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
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
