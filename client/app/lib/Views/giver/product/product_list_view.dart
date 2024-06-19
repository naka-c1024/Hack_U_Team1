import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../Domain/furniture.dart';
import 'product_cell.dart';

class ProductListView extends HookConsumerWidget {
  final bool isCompleted;
  const ProductListView({
    required this.isCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Container(
      color: const Color(0xffffffff),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(),
              ProductCell(furniture: furniture, isCompleted: isCompleted),
              ProductCell(furniture: furniture, isCompleted: isCompleted),
            ],
          ),
        ),
      ),
    );
  }
}
