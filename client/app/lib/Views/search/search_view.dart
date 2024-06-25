import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Usecases/provider.dart';
import 'select_category_view.dart';
import 'room_picture_view.dart';
import 'space_measurement_view.dart';
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

    useEffect(() {
      Future.microtask(() => {
            ref.read(categoryProvider.notifier).state = -1,
            ref.read(colorProvider.notifier).state = -1,
            ref.read(reasonProvider.notifier).state = null,
            ref.read(heightProvider.notifier).state = null,
            ref.read(widthProvider.notifier).state = null,
            ref.read(depthProvider.notifier).state = null,
          });
      return null;
    }, []);

    final searchPictureViewList = useState<List<Widget>>(
      [SelectCategoryView(searchPictureProcess: searchPictureProcess)],
    );

    // 画面を重ねて表示
    useEffect(() {
      if (searchPictureProcess.value == 0) {
        if (searchPictureViewList.value.length == 2) {
          searchPictureViewList.value.removeAt(1);
        }
      }
      if (searchPictureProcess.value == 1) {
        if (searchPictureViewList.value.length == 1) {
          searchPictureViewList.value.add(
            RoomPictureView(
              searchPictureProcess: searchPictureProcess,
              cameraController: cameraController,
            ),
          );
        }
        if (searchPictureViewList.value.length == 3) {
          searchPictureViewList.value.removeAt(2);
        }
      }
      if (searchPictureProcess.value == 2) {
        if (searchPictureViewList.value.length == 2) {
          searchPictureViewList.value.add(
            SpaceMeasurementView(searchPictureProcess: searchPictureProcess),
          );
        }
      }
      return null;
    }, [searchPictureProcess.value]);

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
            Stack(children: searchPictureViewList.value),
            const KeywordSearchView(),
          ],
        ),
      ),
    );
  }
}
