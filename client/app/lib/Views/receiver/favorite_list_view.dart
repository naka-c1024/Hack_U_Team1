import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoriteListView extends HookConsumerWidget {
  final List<Row> favoriteAllList;
  const FavoriteListView({required this.favoriteAllList, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        backgroundColor: const Color(0xffffffff),
        automaticallyImplyLeading: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'いいねした商品',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        color: const Color(0xffffffff),
        child: SingleChildScrollView(
          child: favoriteAllList.isEmpty
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    Column(children: favoriteAllList),
                    const SizedBox(height: 40),
                  ],
                ),
        ),
      ),
    );
  }
}
