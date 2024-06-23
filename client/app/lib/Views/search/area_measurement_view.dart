import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/constants.dart';
import '../../Usecases/provider.dart';
import './../common/cateogory_cell.dart';

class AreaMeasurementView extends HookConsumerWidget {
  final ValueNotifier<bool> isCamera;
  const AreaMeasurementView({
    required this.isCamera,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    final arkitController = useState<ARKitController?>(null);
    final nodes = useState<List<ARKitNode>>([]); // 設置した球体を保持
    final positions = useState<List<vector.Vector3>>([]); // 球体の座標を保持

    final isMeasuringHeight = useState(false);
    final isMeasuringWidth = useState(false);
    final isMeasuringDepth = useState(false);
    final height = useState<int?>(null);
    final width = useState<int?>(null);
    final depth = useState<int?>(null);

    useEffect(() {
      return () => arkitController.value?.dispose();
    }, []);

    // 画面上の球体を削除
    void removeAllSpheres(ARKitController controller) {
      for (final node in nodes.value) {
        controller.remove(node.name);
      }
      nodes.value.clear();
      positions.value.clear();
    }

    // タップしたところに球体を設置
    void addSphereAtPosition(
      vector.Vector3 position,
      ARKitController controller,
    ) {
      if (isMeasuringHeight.value ||
          isMeasuringWidth.value ||
          isMeasuringDepth.value) {
        if (positions.value.length < 2) {
          final material = ARKitMaterial(
            diffuse: ARKitMaterialProperty.color(const Color(0xff7ddb0f)),
          );
          final sphere = ARKitSphere(materials: [material], radius: 0.01);
          final node = ARKitNode(geometry: sphere, position: position);
          controller.add(node);
          nodes.value.add(node);
          positions.value.add(position);
          // 球体が二つ設置されたら距離を計算
          if (positions.value.length == 2) {
            final distance = positions.value[0].distanceTo(positions.value[1]);
            if (isMeasuringHeight.value) {
              height.value = (distance * 100).round();
              isMeasuringHeight.value = false;
            }
            if (isMeasuringWidth.value) {
              width.value = (distance * 100).round();
              isMeasuringWidth.value = false;
            }
            if (isMeasuringDepth.value) {
              depth.value = (distance * 100).round();
              isMeasuringDepth.value = false;
            }
            // 画面上の球体を削除
            Future.delayed(const Duration(seconds: 1), () {
              removeAllSpheres(controller);
            });
          }
        }
      }
    }

    void onARKitViewCreated(ARKitController controller) {
      controller.onARTap = (List<ARKitTestResult> hits) {
        if (hits.isNotEmpty) {
          final hit = hits.first;
          final position = vector.Vector3(
              hit.worldTransform.getColumn(3).x,
              hit.worldTransform.getColumn(3).y,
              hit.worldTransform.getColumn(3).z);
          addSphereAtPosition(position, controller);
        }
      };
    }

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
          // 長さを測るためのカメラ
          // SizedBox(
          //   height: screenSize.height - 196,
          //   child: ARKitSceneView(
          //     enableTapRecognizer: true,
          //     onARKitViewCreated: (controller) {
          //       arkitController.value = controller;
          //       onARKitViewCreated(controller);
          //     },
          //   ),
          // ),
          // ボタンやテキスト
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 440, 24, 32),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Column(
                      children: [
                        const Text(
                          '想定する家具の大きさを指定できます',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  isMeasuringHeight.value = true;
                                  isMeasuringWidth.value = false;
                                  isMeasuringDepth.value = false;
                                },
                                child: Container(
                                  height: 32,
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  color: Colors.transparent,
                                  alignment: Alignment.center,
                                  child: Text(
                                    isMeasuringHeight.value
                                        ? '高さを計測中'
                                        : height.value == null
                                            ? '高さを計測'
                                            : '高さ：${height.value} cm',
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  isMeasuringHeight.value = false;
                                  isMeasuringWidth.value = true;
                                  isMeasuringDepth.value = false;
                                },
                                child: Container(
                                  height: 32,
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  color: Colors.transparent,
                                  alignment: Alignment.center,
                                  child: Text(
                                    isMeasuringWidth.value
                                        ? '幅を計測中'
                                        : width.value == null
                                            ? '幅を計測'
                                            : '幅：${width.value} cm',
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  isMeasuringHeight.value = false;
                                  isMeasuringWidth.value = false;
                                  isMeasuringDepth.value = true;
                                },
                                child: Container(
                                  height: 32,
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  color: Colors.transparent,
                                  alignment: Alignment.center,
                                  child: Text(
                                    isMeasuringDepth.value
                                        ? '奥行きを計測中'
                                        : depth.value == null
                                            ? '奥行きを計測'
                                            : '奥行き：${depth.value} cm',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 戻るボタン
                  ElevatedButton(
                    onPressed: () {
                    isCamera.value = true;
                    },
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
                        Icons.photo_camera_outlined,
                        size: 28,
                        color: Color(0xffd9d9d9),
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  // 検索ボタン
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
                        onPressed: () {},
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
                                menuHeight.value == 48.0 && selectedIndex != -1
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
