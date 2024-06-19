import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/cateogory_cell.dart';

class CategorySheet extends HookConsumerWidget {
  const CategorySheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop(0);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              const Text(
                'カテゴリー',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryCell(categoryIndex: 0, isSheet: true),
                    CategoryCell(categoryIndex: 1, isSheet: true),
                    CategoryCell(categoryIndex: 2, isSheet: true),
                    CategoryCell(categoryIndex: 3, isSheet: true),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryCell(categoryIndex: 4, isSheet: true),
                    CategoryCell(categoryIndex: 5, isSheet: true),
                    CategoryCell(categoryIndex: 6, isSheet: true),
                    CategoryCell(categoryIndex: 7, isSheet: true),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryCell(categoryIndex: 8, isSheet: true),
                    CategoryCell(categoryIndex: 9, isSheet: true),
                    CategoryCell(categoryIndex: 10, isSheet: true),
                    CategoryCell(categoryIndex: 11, isSheet: true),
                  ],
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
