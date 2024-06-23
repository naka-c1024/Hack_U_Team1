import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../Usecases/provider.dart';

class RegisterSizeSheet extends HookConsumerWidget {
  final ValueNotifier<String?> imagePath;
  const RegisterSizeSheet({
    required this.imagePath,
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
      decoration: const BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop(0);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              const Text(
                'サイズを計測',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          // 長さを測るためのカメラ
          SizedBox(
            height: screenSize.width + 120,
            child: ARKitSceneView(
              enableTapRecognizer: true,
              onARKitViewCreated: (controller) {
                arkitController.value = controller;
                onARKitViewCreated(controller);
              },
            ),
          ),
          const Spacer(),
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
                    padding: const EdgeInsets.only(left: 8, right: 8),
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
                    padding: const EdgeInsets.only(left: 8, right: 8),
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
                    padding: const EdgeInsets.only(left: 8, right: 8),
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
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              // 長さ登録ボタン
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (height != null && width != null && depth != null) {
                      Navigator.of(context).pop(1);
                      Navigator.of(context).pop(1);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff424242),
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Container(
                    height: 48,
                    width: screenSize.width - 48,
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    alignment: Alignment.center,
                    child: const Text(
                      'サイズを登録',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffffffff),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
