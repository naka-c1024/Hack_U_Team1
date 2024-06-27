import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/theme_color.dart';
import '../../Domain/constants.dart';
import '../../Usecases/provider.dart';
import 'search_result_view.dart';

class SpaceMeasurementView extends HookConsumerWidget {
  final ValueNotifier<int> searchPictureProcess;
  const SpaceMeasurementView({
    required this.searchPictureProcess,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final categoryIndex = ref.watch(categoryProvider);

    final arkitController = useState<ARKitController?>(null);
    final nodes = useState<List<ARKitNode>>([]); // 設置した球体を保持
    final positions = useState<List<vector.Vector3>>([]); // 球体の座標を保持

    final isMeasuringHeight = useState(false);
    final isMeasuringWidth = useState(false);
    final isMeasuringDepth = useState(false);
    final height = ref.watch(heightProvider);
    final width = ref.watch(widthProvider);
    final depth = ref.watch(depthProvider);

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
            diffuse: ARKitMaterialProperty.color(ThemeColors.keyGreen),
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
              ref.read(heightProvider.notifier).state =
                  (distance * 100).round();
              isMeasuringHeight.value = false;
            }
            if (isMeasuringWidth.value) {
              ref.read(widthProvider.notifier).state = (distance * 100).round();
              isMeasuringWidth.value = false;
            }
            if (isMeasuringDepth.value) {
              ref.read(depthProvider.notifier).state = (distance * 100).round();
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

    return Container(
      height: screenSize.height,
      width: screenSize.width,
      color: const Color(0xffffffff),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ページの進捗表示
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  searchPictureProcess.value = 1;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffffffff),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Container(
                  height: 40,
                  width: 72,
                  padding: const EdgeInsets.only(left: 8),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: ThemeColors.black,
                      ),
                      Text(
                        '戻る',
                        style: TextStyle(
                          color: ThemeColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.keyGreen,
                ),
              ),
              Container(
                height: 2,
                width: 48,
                color: ThemeColors.keyGreen,
              ),
              Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.keyGreen,
                ),
              ),
              Container(
                height: 2,
                width: 48,
                color: ThemeColors.keyGreen,
              ),
              Container(
                height: 28,
                width: 28,
                padding: const EdgeInsets.only(bottom: 4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.keyGreen,
                ),
                child: const Center(
                  child: Text(
                    '3',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(width: 64),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            '想定する家具の大きさを指定できます',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              // 長さを測るためのカメラ
              Container(
                height: screenSize.height - 324,
                color: const Color(0xff000000),
                child: ARKitSceneView(
                  enableTapRecognizer: true,
                  onARKitViewCreated: (controller) {
                    arkitController.value = controller;
                    onARKitViewCreated(controller);
                  },
                ),
              ),
              Column(
                children: [
                  // 計測ボタン
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 376, 16, 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Container(
                        height: 64,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  isMeasuringHeight.value = false;
                                  isMeasuringWidth.value = true;
                                  isMeasuringDepth.value = false;
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 32,
                                      color: Colors.transparent,
                                      alignment: Alignment.center,
                                      child: Text(
                                        isMeasuringWidth.value
                                            ? '幅を計測中'
                                            : width == null
                                                ? '幅を計測'
                                                : '幅：$width cm',
                                      ),
                                    ),
                                    Container(
                                      height: 4,
                                      width: 72,
                                      color: isMeasuringWidth.value
                                          ? ThemeColors.keyGreen
                                          : Colors.transparent,
                                    ),
                                  ],
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
                                child: Column(
                                  children: [
                                    Container(
                                      height: 32,
                                      color: Colors.transparent,
                                      alignment: Alignment.center,
                                      child: Text(
                                        isMeasuringDepth.value
                                            ? '奥行きを計測中'
                                            : depth == null
                                                ? '奥行きを計測'
                                                : '奥行き：$depth cm',
                                      ),
                                    ),
                                    Container(
                                      height: 4,
                                      width: 112,
                                      color: isMeasuringDepth.value
                                          ? ThemeColors.keyGreen
                                          : Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  isMeasuringHeight.value = true;
                                  isMeasuringWidth.value = false;
                                  isMeasuringDepth.value = false;
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 32,
                                      color: Colors.transparent,
                                      alignment: Alignment.center,
                                      child: Text(
                                        isMeasuringHeight.value
                                            ? '高さを計測中'
                                            : height == null
                                                ? '高さを計測'
                                                : '高さ：$height cm',
                                      ),
                                    ),
                                    Container(
                                      height: 4,
                                      width: 88,
                                      color: isMeasuringHeight.value
                                          ? ThemeColors.keyGreen
                                          : Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 検索ボタン
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultView(
                            searchWord: '${categorys[categoryIndex]} の画像検索結果',
                            isSearchPicture: true,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.keyGreen,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Container(
                      height: 48,
                      width: screenSize.width - 80,
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      alignment: Alignment.center,
                      child: const Text(
                        '検索する',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
