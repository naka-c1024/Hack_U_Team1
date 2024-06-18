import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/constants.dart';
import 'package:app/Domain/furniture.dart';
import 'package:app/Views/components/trade_adjust_menu.dart';

class FurnitureDetailView extends HookConsumerWidget {
  const FurnitureDetailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final furniture = Furniture(
      productName: "ガラス天板のローテーブル",
      image: null,
      description: "ローテーブルの説明文ローテーブルの説明文ローテーブルの説明文ローテーブルの説明文ローテーブルの説明文",
      height: 35.0,
      width: 100.0,
      depth: 42.0,
      category: 2,
      color: 2,
      condition: 3,
      userName: 'ibuibukiki',
      area: 12,
      startDate: DateTime(2024, 7, 1),
      endDate: DateTime(2024, 7, 19),
      tradePlace: '高田馬場駅',
      isSold: false,
      isFavorite: false,
    );

    final isFavorite = useState(furniture.isFavorite);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 56),
          Container(
            height: screenSize.height - 56,
            color: const Color(0xffffffff),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 商品画像
                  Stack(
                    children: [
                      // TODO: ここに写真が入る
                      Container(
                        height: screenSize.width,
                        width: screenSize.width,
                        color: const Color(0xffd9d9d9),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(left: 8),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xffd9d9d9),
                        ), // 戻るボタンの色を指定
                        onPressed: () {
                          Navigator.of(context).pop(0);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              furniture.productName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // いいねボタン
                            ElevatedButton(
                              onPressed: () {
                                isFavorite.value = !isFavorite.value;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffffffff),
                                foregroundColor: isFavorite.value
                                    ? const Color(0xff474747)
                                    : const Color(0xff858585),
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Container(
                                height: 24,
                                width: 72,
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(),
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(Icons.favorite, size: 16),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 2),
                                      child: Text('いいね',
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '商品説明',
                          style: TextStyle(
                            color: Color(0xff6a6a6a),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          furniture.description,
                          style: const TextStyle(
                            color: Color(0xff636363),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          '引き渡しについて',
                          style: TextStyle(
                            color: Color(0xff6a6a6a),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Divider(),
                        const SizedBox(height: 4),
                        // 引き渡し期間
                        Row(
                          children: [
                            const SizedBox(
                              width: 96,
                              child: Text(
                                '可能期間',
                                style: TextStyle(
                                  color: Color(0xff636363),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              (furniture.startDate == null &&
                                      furniture.endDate == null)
                                  ? '無期限'
                                  : furniture.startDate == null
                                      ? ' 〜 ${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.endDate!)}'
                                      : furniture.endDate == null
                                          ? '${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.startDate!)} 〜 '
                                          : '${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.startDate!)} 〜 ${DateFormat('yyyy年MM月dd日(E)', 'ja').format(furniture.endDate!)}',
                              style: const TextStyle(
                                color: Color(0xff636363),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 引き渡し場所
                        Row(
                          children: [
                            const SizedBox(
                              width: 96,
                              child: Text(
                                '場所',
                                style: TextStyle(
                                  color: Color(0xff636363),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              furniture.tradePlace,
                              style: const TextStyle(
                                color: Color(0xff636363),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Divider(),
                        const SizedBox(height: 24),
                        const Text(
                          '商品の情報',
                          style: TextStyle(
                            color: Color(0xff6a6a6a),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Divider(),
                        const SizedBox(height: 4),
                        // サイズ
                        Row(
                          children: [
                            const SizedBox(
                              width: 96,
                              child: Text(
                                'サイズ',
                                style: TextStyle(
                                  color: Color(0xff636363),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '幅${furniture.width}cm × 奥行き${furniture.depth}cm × 高さ${furniture.height}cm',
                              style: const TextStyle(
                                color: Color(0xff636363),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // カテゴリ
                        Row(
                          children: [
                            const SizedBox(
                              width: 96,
                              child: Text(
                                'カテゴリ',
                                style: TextStyle(
                                  color: Color(0xff636363),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              categorys[furniture.category],
                              style: const TextStyle(
                                color: Color(0xff636363),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 色味
                        Row(
                          children: [
                            const SizedBox(
                              width: 96,
                              child: Text(
                                '色味',
                                style: TextStyle(
                                  color: Color(0xff636363),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              height: 16,
                              width: 16,
                              decoration: const BoxDecoration(
                                color: Color(0xffd9d9d9),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              colors[furniture.color],
                              style: const TextStyle(
                                color: Color(0xff636363),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 商品の状態
                        Row(
                          children: [
                            const SizedBox(
                              width: 96,
                              child: Text(
                                '商品の状態',
                                style: TextStyle(
                                  color: Color(0xff636363),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              conditions[furniture.condition],
                              style: const TextStyle(
                                color: Color(0xff636363),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Divider(),
                        const SizedBox(height: 24),
                        const Text(
                          '出品者',
                          style: TextStyle(
                            color: Color(0xff6a6a6a),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Divider(),
                        // 出品者情報
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xffd9d9d9),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  furniture.userName,
                                  style: const TextStyle(
                                    color: Color(0xff636363),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  prefectures[furniture.area],
                                  style: const TextStyle(
                                    color: Color(0xff636363),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 24),
                        // 取引依頼ボタン
                        ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: screenSize.height - 64,
                                  child: TradeAdjustMenu(furniture: furniture),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff424242),
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Container(
                            height: 48,
                            width: screenSize.width - 48,
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            alignment: Alignment.center,
                            child: const Text(
                              '取引をお願いする',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xffffffff),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 64),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
