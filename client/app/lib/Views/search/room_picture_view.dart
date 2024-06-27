// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/theme_color.dart';
import '../../Usecases/ai_api.dart';
import '../common/error_dialog.dart';

class RoomPictureView extends HookConsumerWidget {
  final ValueNotifier<int> searchPictureProcess;
  final ValueNotifier<CameraController?> cameraController;
  const RoomPictureView({
    required this.cameraController,
    required this.searchPictureProcess,
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

    return Container(
      height: screenSize.height,
      width: screenSize.width,
      color: const Color(0xffffffff),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ページの進捗表示
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  searchPictureProcess.value = 0;
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
                height: 28,
                width: 28,
                padding: const EdgeInsets.only(bottom: 4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.keyGreen,
                ),
                child: const Center(
                  child: Text(
                    '2',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 48,
                color: ThemeColors.lineGray1,
              ),
              Container(
                height: 8,
                width: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeColors.lineGray1,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 64),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              // カメラ
              Column(
                children: [
                  const Text(
                    '部屋の全体を撮影して\n部屋にあった家具をおすすめします',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  cameraController.value?.value.isInitialized ?? false
                      ? AspectRatio(
                          aspectRatio:
                              1 / cameraController.value!.value.aspectRatio,
                          child: CameraPreview(cameraController.value!),
                        )
                      : Container(
                          height: 464,
                          color: const Color(0x53000000),
                        ),
                ],
              ),
              // ボタンやテキスト
              Padding(
                padding: const EdgeInsets.only(top: 440),
                child: Row(
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
                            color: ThemeColors.bgGray1,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.image_outlined,
                          size: 28,
                          color: ThemeColors.bgGray1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
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
                              color: const Color(0xffffffff),
                              width: 4,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            searchPictureProcess.value = 2;
                            if (cameraController.value == null) {
                              const message =
                                  'Error: camera Controller is null.';
                              showErrorDialog(context, message);
                              return;
                            }
                            try {
                              final image =
                                  await cameraController.value?.takePicture();
                              if (image == null) {
                                const message = 'Error: image is null.';
                                showErrorDialog(context, message);
                                return;
                              }
                              recommendFurniture(ref, image.path);
                            } catch (e) {
                              showErrorDialog(context, e.toString());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.all(4),
                            elevation: 0,
                          ),
                          child: Container(
                            height: 48,
                            width: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xffffffff),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 40),
                    const SizedBox(height: 48, width: 48),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
