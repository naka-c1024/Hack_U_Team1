import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Usecases/provider.dart';
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

    final furnitureState = ref.watch(furnitureListProvider);
    final tradeState = ref.watch(tradeListProvider);

    // 画面を更新
    Future<void> reloadFurnitureList() {
      // ignore: unused_result
      ref.refresh(furnitureListProvider);
      return ref.read(furnitureListProvider.future);
    }

    Future<void> reloadTradeList() {
      // ignore: unused_result
      ref.refresh(tradeListProvider);
      return ref.read(tradeListProvider.future);
    }

    // 画面を移動した時に自動で更新
    useEffect(() {
      reloadFurnitureList();
      reloadTradeList();
      return null;
    }, [selectedView.value]);

    final viewWidgets = [
      // 下に引っ張った時に更新
      RefreshIndicator(
        onRefresh: () => reloadFurnitureList(),
        // 家具リストの取得
        child: furnitureState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, __) => Center(
            child: Text('$error'),
          ),
          skipLoadingOnRefresh: false,
          data: (data) {
            return FurnitureListView(
              furnitureList: data,
              selectedView: selectedView,
            );
          },
        ),
      ),
      SearchView(cameraController: cameraController),
      // 下に引っ張った時に更新
      RefreshIndicator(
        onRefresh: () => reloadTradeList(),
        // 取引リストの取得
        child: tradeState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, __) => Center(
            child: Text('$error'),
          ),
          skipLoadingOnRefresh: false,
          data: (data) {
            return RegisterProductView(
              tradeList: data,
              cameraController: cameraController,
            );
          },
        ),
      ),
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
        selectedItemColor: const Color(0xff3e3e3e),
        unselectedItemColor: const Color(0xff3e3e3e),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xff636363),
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Color(0xff636363),
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
