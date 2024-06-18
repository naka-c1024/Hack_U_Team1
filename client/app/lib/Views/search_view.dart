import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/Views/picture_search_view.dart';
import 'package:app/Views/keyword_search_view.dart';

// 選択したカテゴリをインデックスで保持
final categoryProvider = StateProvider((ref) => -1);

class SearchView extends HookConsumerWidget {
  final CameraDescription? camera;
  const SearchView({super.key,required this.camera});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 8,
          backgroundColor: const Color(0xffffffff),
          title: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  '写真',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'キーワード',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PictureSearchView(camera: camera),
            const KeywordSearchView(),
          ],
        ),
      ),
    );
  }
}
