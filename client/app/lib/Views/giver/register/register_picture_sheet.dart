import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../Usecases/ai_api.dart';
import 'register_size_sheet.dart';

class RegisterPictureSheet extends HookConsumerWidget {
  final ValueNotifier<CameraController?> cameraController;
  final ValueNotifier<String?> imagePath;
  const RegisterPictureSheet({
    required this.cameraController,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isCamera = useState(true);

    // カメラ関連の初期化処理
    useEffect(() {
      Future<void> initializeController() async {
        await cameraController.value?.initialize();
      }

      initializeController();
      return null;
    }, []);

    // カメラかプレビューか
    useEffect(() {
      if (imagePath.value == null) {
        isCamera.value = true;
      } else {
        isCamera.value = false;
      }
      return null;
    }, []);

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
                '写真',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          isCamera.value
              // カメラ
              ? SizedBox(
                  height: screenSize.width + 120,
                  child: cameraController.value?.value.isInitialized ?? false
                      ? CameraPreview(cameraController.value!)
                      : Container(
                          color: const Color(0x53000000),
                        ),
                )
              : SizedBox(
                  height: screenSize.width + 120,
                  child: Image.file(File(imagePath.value!)),
                ),
          const Spacer(),
          isCamera.value
              ? Row(
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
                              color: const Color(0xff595959), width: 1),
                        ),
                        child: const Icon(
                          Icons.image_outlined,
                          size: 28,
                          color: Color(0xff595959),
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
                                color: const Color(0xff595959), width: 2),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (cameraController.value == null) {
                              print('Error: camera Controller is null.');
                              return;
                            }
                            try {
                              final image =
                                  await cameraController.value?.takePicture();
                              if (image == null) {
                                print('Error: image is null.');
                                return;
                              }
                              imagePath.value = image.path;
                              isCamera.value = false;
                            } catch (e) {
                              print(e);
                            }
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
                              color: Color(0xff595959),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.photo_camera_outlined,
                              size: 32,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    const SizedBox(height: 48, width: 48),
                  ],
                )
              : Column(
                  children: [
                    // 写真決定ボタン
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          if (imagePath.value != null) {
                            describeFurniture(ref, imagePath.value!);
                          }
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: screenSize.height - 64,
                                child: RegisterSizeSheet(
                                  imagePath: imagePath,
                                ),
                              );
                            },
                          );
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
                            'この写真にする',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 撮影しなおすボタン
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          imagePath.value = null;
                          isCamera.value = true;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffffffff),
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Color(0xff424242),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Container(
                          height: 48,
                          width: screenSize.width - 48,
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          alignment: Alignment.center,
                          child: const Text(
                            '撮影しなおす',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff424242),
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
