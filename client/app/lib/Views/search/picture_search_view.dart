import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/constants.dart';
import '../../Usecases/provider.dart';
import './../common/cateogory_cell.dart';

class PictureSearchView extends HookConsumerWidget {
  final ValueNotifier<CameraController?> cameraController;
  final ValueNotifier<bool> isCamera;
  const PictureSearchView({
    required this.cameraController,
    required this.isCamera,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    // カメラ関連の初期化処理
    useEffect(() {
      Future<void> initializeController() async {
        await cameraController.value?.initialize();
      }

      initializeController();
      return null;
    }, []);

    final menuHeight = useState(48.0);
    void toggleHeight() {
      menuHeight.value = menuHeight.value == 48.0 ? 560.0 : 48.0;
    }

    final selectedIndex = ref.watch(categoryProvider);

    // カテゴリ未選択時に最初からカテゴリ一メニューを表示
    useEffect(() {
      if (selectedIndex == -1) {
        menuHeight.value = 560;
      }
      return null;
    }, []);

    // カテゴリを選んだらカテゴリメニューを閉じる
    useEffect(() {
      if (selectedIndex != -1) {
        menuHeight.value = 48;
      }
      return null;
    }, [selectedIndex]);

    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: screenSize.height - 196,
            width: screenSize.width,
            color: const Color(0x53000000),
          ),
          // カメラ
          Column(
            children: [
              const SizedBox(height: 48),
              SizedOverflowBox(
                size: Size(
                    (screenSize.height - 196) / 4 * 3, screenSize.height - 196),
                child: cameraController.value?.value.isInitialized ?? false
                    ? CameraPreview(cameraController.value!)
                    : Container(
                        color: const Color(0x53000000),
                      ),
              ),
            ],
          ),
          // ボタンやテキスト
          Column(
            children: [
              Container(
                height: 24,
                width: 248,
                margin: const EdgeInsets.only(top: 504),
                color: const Color(0x23000000),
                alignment: Alignment.center,
                child: const Text(
                  'シャッターボタンをタップして検索',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // アルバムから持ってくるボタン
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.all(4),
                      minimumSize: Size.zero,
                      elevation: 0,
                    ),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xffd9d9d9), width: 1),
                      ),
                      child: const Icon(
                        Icons.image_outlined,
                        size: 28,
                        color: Color(0xffd9d9d9),
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  // シャッターボタン
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xffd9d9d9), width: 2),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          isCamera.value = false;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.all(4),
                          elevation: 0,
                        ),
                        child: Container(
                          height: 56,
                          width: 56,
                          decoration: const BoxDecoration(
                            color: Color(0xffd9d9d9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.search, size: 32),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 32),
                  const SizedBox(height: 48, width: 48),
                ],
              ),
            ],
          ),
          menuHeight.value == 48.0
              ? const SizedBox()
              : Container(
                  color: const Color(0x53000000),
                ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              children: [
                // カテゴリメニュー
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  height: menuHeight.value,
                  padding: const EdgeInsets.only(left: 24, top: 8, right: 24),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // 常に見えている部分がボタン
                        GestureDetector(
                          onTap: () {
                            if (selectedIndex != -1) {
                              toggleHeight();
                            }
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                menuHeight.value == 48.0
                                    ? Container(
                                        height: 32,
                                        width: 32,
                                        decoration: const BoxDecoration(
                                          color: Color(0xffd9d9d9),
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : const SizedBox(width: 24),
                                const SizedBox(width: 16),
                                menuHeight.value == 48.0
                                    ? Text(
                                        categorys[selectedIndex],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const Text(
                                        'どんな家具を置きたいですか？',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                const Spacer(),
                                menuHeight.value == 48.0
                                    ? const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 32,
                                      )
                                    : const Icon(
                                        Icons.keyboard_arrow_up,
                                        size: 32,
                                      ),
                              ],
                            ),
                          ),
                        ),
                        // カテゴリ選択時のみ表示
                        menuHeight.value == 48.0
                            ? const SizedBox()
                            : const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CategoryCell(categoryIndex: 0),
                                      CategoryCell(categoryIndex: 1),
                                      CategoryCell(categoryIndex: 2),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CategoryCell(categoryIndex: 3),
                                      CategoryCell(categoryIndex: 4),
                                      CategoryCell(categoryIndex: 5),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CategoryCell(categoryIndex: 6),
                                      CategoryCell(categoryIndex: 7),
                                      CategoryCell(categoryIndex: 8),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CategoryCell(categoryIndex: 9),
                                      CategoryCell(categoryIndex: 10),
                                      CategoryCell(categoryIndex: 11),
                                    ],
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
