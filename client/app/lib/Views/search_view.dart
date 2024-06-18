import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/Views/picture_search_view.dart';
import 'package:app/Views/keyword_search_view.dart';

class SearchView extends HookConsumerWidget {
  final ValueNotifier<CameraController?> cameraController;
  const SearchView({
    required this.cameraController,
    super.key,
  });

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
            PictureSearchView(cameraController: cameraController),
            const KeywordSearchView(),
          ],
        ),
      ),
    );
  }
}
