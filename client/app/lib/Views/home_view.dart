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
        ResolutionPreset.max,
        enableAudio: false,
      );
      return null;
    }, [camera]);

    final furnitureState = ref.watch(furnitureListProvider);
    final tradeState = ref.watch(tradeListProvider);
    final viewWidgets = [
      // 家具リストの取得
      furnitureState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, __) => Center(
          child: Text('$error'),
        ),
        data: (data) {
          return FurnitureListView(furnitureList: data);
        },
      ),
      SearchView(cameraController: cameraController),
      // 取引リストの取得
      tradeState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, __) => Center(
          child: Text('$error'),
        ),
        data: (data) {
          return RegisterProductView(
            tradeList: data,
            cameraController: cameraController,
          );
        },
      ),
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
