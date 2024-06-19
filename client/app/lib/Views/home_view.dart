import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/Views/search_view.dart';
import 'package:app/Views/my_page_view.dart';
import 'package:app/Views/furniture_list_view.dart';
import 'package:app/Views/register_product_view.dart';

class HomeView extends HookConsumerWidget {
  final CameraDescription? camera;
  const HomeView({super.key, required this.camera});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedView = useState(0);
    final ValueNotifier<CameraController?> cameraController = useState(null);

    // カメラ関連の初期化処理
    useEffect(() {
      if (camera == null) {
        return null;
      }
      cameraController.value = CameraController(
        camera!,
        ResolutionPreset.max,
        enableAudio: false,
      );
      return null;
    }, [camera]);

    final viewWidgets = [
      const FurnitureListView(),
      SearchView(cameraController: cameraController),
      RegisterProductView(cameraController: cameraController),
      MyPageView(camera: camera),
    ];

    return Scaffold(
      body: viewWidgets.elementAt(selectedView.value),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '検索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera_outlined),
            label: '出品',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'マイページ',
          ),
        ],
        iconSize: 20,
        elevation: 8,
        backgroundColor: const Color(0xffffffff),
        currentIndex: selectedView.value,
        onTap: (value) => {
          selectedView.value = value,
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
