import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/theme_color.dart';
import './../common/cateogory_cell.dart';

class SelectCategoryView extends HookConsumerWidget {
  final ValueNotifier<int> searchPictureProcess;
  const SelectCategoryView({
    required this.searchPictureProcess,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height,
      width: screenSize.width,
      color: const Color(0xffffffff),
      padding: const EdgeInsets.fromLTRB(16,18,16,16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ページの進捗表示
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 28,
                width: 28,
                padding: const EdgeInsets.only(bottom: 4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.keyGreen,
                ),
                child: const Center(
                  child: Text(
                    '1',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 44,
                color: ThemeColors.lineGray1,
              ),
              Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.lineGray1,
                ),
              ),
              Container(
                height: 2,
                width: 60,
                color: ThemeColors.lineGray1,
              ),
              Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.lineGray1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            '  どんな家具を置きたいですか？',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CategoryCell(categoryIndex: 0,searchPictureProcess: searchPictureProcess,),
              CategoryCell(categoryIndex: 1,searchPictureProcess: searchPictureProcess,),
              CategoryCell(categoryIndex: 2,searchPictureProcess: searchPictureProcess,),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CategoryCell(categoryIndex: 3,searchPictureProcess: searchPictureProcess,),
              CategoryCell(categoryIndex: 4,searchPictureProcess: searchPictureProcess,),
              CategoryCell(categoryIndex: 5,searchPictureProcess: searchPictureProcess,),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CategoryCell(categoryIndex: 6,searchPictureProcess: searchPictureProcess,),
              CategoryCell(categoryIndex: 7,searchPictureProcess: searchPictureProcess,),
              CategoryCell(categoryIndex: 8,searchPictureProcess: searchPictureProcess,),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CategoryCell(categoryIndex: 9,searchPictureProcess: searchPictureProcess,),
              CategoryCell(categoryIndex: 10,searchPictureProcess: searchPictureProcess,),
              CategoryCell(categoryIndex: 11,searchPictureProcess: searchPictureProcess,),
            ],
          ),
        ],
      ),
    );
  }
}
