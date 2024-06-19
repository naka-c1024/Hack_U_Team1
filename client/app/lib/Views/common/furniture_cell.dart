import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/furniture.dart';
import 'furniture_detail_view.dart';
import 'sold_painter.dart';

class FurnitureCell extends HookConsumerWidget {
  final String prefecture;
  final bool isSold;

  const FurnitureCell({
    required this.prefecture,
    required this.isSold,
    super.key,
  });

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

    return ElevatedButton(
      onPressed: () {
        // 家具の詳細ページへ
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FurnitureDetailView(
              furniture: furniture,
              isMyProduct: false,
              isHiddenButton: false,
            ),
          ),
        );
      },
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
        margin: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xffd9d9d9),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            //TODO: ここに写真が入る
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isSold
                    ? CustomPaint(
                        size: const Size(52, 52),
                        painter: SoldPainter(),
                      )
                    : const SizedBox(),
                Container(
                  height: 24,
                  width: 64,
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  decoration: BoxDecoration(
                    color: const Color(0x2b666666),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    prefecture,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            isSold
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        transform: Matrix4.rotationZ(-45 * pi / 180),
                        transformAlignment: Alignment.center,
                        child: const Text(
                          ' SOLD',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
