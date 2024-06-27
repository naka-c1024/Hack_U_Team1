import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Domain/theme_color.dart';
import 'search/search_view.dart';
import 'user/my_page_view.dart';
import 'receiver/furniture_list_view.dart';
import 'giver/register_product_view.dart';

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
        ResolutionPreset.medium,
        enableAudio: false,
      );
      return null;
    }, [camera]);

    final viewWidgets = [
      FurnitureListView(selectedView: selectedView),
      SearchView(cameraController: cameraController),
      RegisterProductView(cameraController: cameraController),
      MyPageView(camera: camera),
    ];

    return Scaffold(
      body: viewWidgets.elementAt(selectedView.value),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset('assets/images/menu_home_fill.png', scale: 2),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset('assets/images/menu_home.png', scale: 2),
            ),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child:
                  Image.asset('assets/images/menu_search_fill.png', scale: 2),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset('assets/images/menu_search.png', scale: 2),
            ),
            label: '検索',
          ),
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child:
                  Image.asset('assets/images/menu_camera_fill.png', scale: 2),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset('assets/images/menu_camera.png', scale: 2),
            ),
            label: '出品',
          ),
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset('assets/images/menu_user_fill.png', scale: 2),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Image.asset('assets/images/menu_user.png', scale: 2),
            ),
            label: 'マイページ',
          ),
        ],
        elevation: 8,
        selectedItemColor: ThemeColors.lineGray2,
        unselectedItemColor: ThemeColors.lineGray2,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: ThemeColors.textGray1,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: ThemeColors.textGray1,
        ),
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
