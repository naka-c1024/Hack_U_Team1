import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TapMeasurementPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arkitController = useState<ARKitController?>(null);
    final positions = useState<List<vector.Vector3>>([]);

    useEffect(() {
      return () => arkitController.value?.dispose();
    }, []);

    void addSphereAtPosition(vector.Vector3 position) {
      final material = ARKitMaterial(diffuse: ARKitMaterialProperty.color(Colors.yellow));
      final sphere = ARKitSphere(materials: [material], radius: 0.01);
      final node = ARKitNode(geometry: sphere, position: position);
      arkitController.value?.add(node);
      positions.value.add(position);
      if (positions.value.length > 2) {
        positions.value.removeAt(0);
      }
    }

    void displayDistance() {
      if (positions.value.length == 2) {
        final distance = positions.value[0].distanceTo(positions.value[1]);
        showDialog<void>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text('Distance: ${distance.toStringAsFixed(2)} meters'),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tap Gesture Sample')),
      body: Container(
        child: ARKitSceneView(
          enableTapRecognizer: true,
          onARKitViewCreated: (controller) {
            arkitController.value = controller;
            controller.onARTap = (List<ARKitTestResult> hits) {
              if (hits.isNotEmpty) {
                final hit = hits.first;
                final position = vector.Vector3(
                  hit.worldTransform.getColumn(3).x,
                  hit.worldTransform.getColumn(3).y,
                  hit.worldTransform.getColumn(3).z
                );
                addSphereAtPosition(position);
                displayDistance();
              }
            };
          },
        ),
      ),
    );
  }
}
