import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'select_category_view.dart';
import 'keyword_search_view.dart';

class SearchView extends HookConsumerWidget {
  final ValueNotifier<CameraController?> cameraController;
  const SearchView({
    required this.cameraController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPictureProcess = useState(0);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xffffffff),
          title: TabBar(
            labelColor: const Color(0xff000000),
            unselectedLabelColor: const Color(0xff000000),
            indicatorColor: Theme.of(context).primaryColor,
            tabs: const [
              Tab(
                child: Text(
                  '      写真      ',
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
            searchPictureProcess.value == 0
                ? SelectCategoryView(searchPictureProcess:searchPictureProcess)
                : searchPictureProcess.value == 1
                    ? Container()
                    : Container(),
            // ? PictureSearchView(
            //     cameraController: cameraController, searchPictureProcess: searchPictureProcess)
            // : AreaMeasurementView(searchPictureProcess: searchPictureProcess),
            const KeywordSearchView(),
          ],
        ),
      ),
    );
  }
}
