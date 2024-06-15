import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/Views/components/furniture_cell.dart';

class FurnitureListView extends HookConsumerWidget {
  const FurnitureListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    const prefecturesIndex = 12;
    final prefectures = [
      '北海道',
      '青森県',
      '岩手県',
      '宮城県',
      '秋田県',
      '山形県',
      '福島県',
      '茨城県',
      '栃木県',
      '群馬県',
      '埼玉県',
      '千葉県',
      '東京都',
      '神奈川県',
      '新潟県',
      '富山県',
      '石川県',
      '福井県',
      '山梨県',
      '長野県',
      '岐阜県',
      '静岡県',
      '愛知県',
      '三重県',
      '滋賀県',
      '京都府',
      '大阪府',
      '兵庫県',
      '奈良県',
      '和歌山県',
      '鳥取県',
      '島根県',
      '岡山県',
      '広島県',
      '山口県',
      '徳島県',
      '香川県',
      '愛媛県',
      '高知県',
      '福岡県',
      '佐賀県',
      '長崎県',
      '熊本県',
      '大分県',
      '宮崎県',
      '鹿児島県',
      '沖縄県'
    ];

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
