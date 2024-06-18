import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/constants.dart';
import 'package:app/Usecases/provider.dart';
import 'package:app/Views/components/color_sheet.dart';
import 'package:app/Views/components/category_sheet.dart';
import 'package:app/Views/components/condition_sheet.dart';
import 'package:app/Views/components/register_picture_sheet.dart';

class RegisterProductSheet extends HookConsumerWidget {
  final ValueNotifier<CameraController?> cameraController;
  const RegisterProductSheet({
    required this.cameraController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final ValueNotifier<String?> imagePath = useState(null);
    final productName = useTextEditingController(text: '');
    final categoryIndex = ref.watch(categoryProvider);
    final colorIndex = ref.watch(colorProvider);
    final conditionIndex = ref.watch(conditionProvider);
    final productWidth = useTextEditingController(text: '');
    final productDepth = useTextEditingController(text: '');
    final productHeight = useTextEditingController(text: '');
    final productDescription = useTextEditingController(text: '');
    final isInputCompleted = useState(false);

    // 一つでも未入力だったら次へ進まない
    bool checkInputCompleted() {
      // TODO: 実機の時にチェック
      // if (imagePath.value == null) {
      //   return false;
      // }
      if (productName.text == '') {
        return false;
      }
      if (categoryIndex == -1) {
        return false;
      }
      if (conditionIndex == -1) {
        return false;
      }
      if (colorIndex == -1) {
        return false;
      }
      if (productWidth.text == '') {
        return false;
      }
      if (productDepth.text == '') {
        return false;
      }
      if (productHeight.text == '') {
        return false;
      }
      if (productDescription.text == '') {
        return false;
      }
      return true;
    }

    useEffect(() {
      isInputCompleted.value = checkInputCompleted();
      return null;
    }, [
      imagePath.value,
      productName.text,
      categoryIndex,
      colorIndex,
      conditionIndex,
      productWidth.text,
      productDepth.text,
      productHeight.text,
      productDescription.text,
    ]);

    final focus = useFocusNode();
    final isFocused = useState(false);

    useEffect(() {
      void onFocusChanged() {
        isFocused.value = focus.hasFocus;
      }

      focus.addListener(onFocusChanged);
      return () => focus.removeListener(onFocusChanged);
    }, [focus]);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffffffff),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          reverse: keyboardHeight == 0 ? false : true,
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
                    icon: const Icon(Icons.close),
                  ),
                  const Text(
                    '商品の情報を入力',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              // ページの進捗表示
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff000000),
                    ),
                  ),
                  Container(
                    height: 2,
                    width: 24,
                    color: const Color(0xffd9d9d9),
                  ),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffd9d9d9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: (isFocused.value == false && keyboardHeight != 0)
                      ? keyboardHeight * 0.75
                      : 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: screenSize.height - 64,
                                  child: RegisterPictureSheet(
                                    cameraController: cameraController,
                                    imagePath: imagePath,
                                  ),
                                );
                              },
                            );
                          },
                          child: Ink(
                            height: 96,
                            width: 96,
                            decoration: BoxDecoration(
                              color: const Color(0xffd9d9d9),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: imagePath.value == null
                                ? const Icon(Icons.photo_camera_outlined)
                                : Image.file(File(imagePath.value!)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    const Text(
                      '商品名',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff686868),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.only(left: 8, bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: const Color(0xffd9d9d9),
                        ),
                      ),
                      child: TextField(
                        focusNode: focus,
                        controller: productName,
                        decoration: const InputDecoration(
                          hintText: '必須 (40文字まで)',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xffd9d9d9),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Divider(),
                    // カテゴリー選択ボタン
                    Row(
                      children: [
                        const Text(
                          'カテゴリー',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff686868),
                          ),
                        ),
                        const Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: screenSize.height - 64,
                                    child: const CategorySheet(),
                                  );
                                },
                              );
                            },
                            child: Ink(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Row(
                                children: [
                                  categoryIndex == -1
                                      ? const Text(
                                          '選択してください',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xffd9d9d9),
                                          ),
                                        )
                                      : Text(
                                          categorys[categoryIndex],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff636363),
                                          ),
                                        ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xff4b4b4b),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    // 商品の状態選択ボタン
                    Row(
                      children: [
                        const Text(
                          '商品の状態',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff686868),
                          ),
                        ),
                        const Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: screenSize.height - 64,
                                    child: const ConditionSheet(),
                                  );
                                },
                              );
                            },
                            child: Ink(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Row(
                                children: [
                                  conditionIndex == -1
                                      ? const Text(
                                          '選択してください',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xffd9d9d9),
                                          ),
                                        )
                                      : Text(
                                          conditions[conditionIndex],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff636363),
                                          ),
                                        ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xff4b4b4b),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    // カラー選択ボタン
                    Row(
                      children: [
                        const Text(
                          'カラー',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff686868),
                          ),
                        ),
                        const Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: screenSize.height - 64,
                                    child: const ColorSheet(),
                                  );
                                },
                              );
                            },
                            child: Ink(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Row(
                                children: [
                                  colorIndex == -1
                                      ? const Text(
                                          '選択してください',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xffd9d9d9),
                                          ),
                                        )
                                      : Text(
                                          colors[colorIndex],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff636363),
                                          ),
                                        ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xff4b4b4b),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 4),
                    const Text(
                      'サイズ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff686868),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // サイズ入力フォーム
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          '幅',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff4b4b4b),
                          ),
                        ),
                        Container(
                          height: 32,
                          width: 56,
                          padding: const EdgeInsets.only(left: 8, bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color(0xffd9d9d9),
                            ),
                          ),
                          child: TextField(
                            controller: productWidth,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const Text(
                          'cm × 奥行き',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff4b4b4b),
                          ),
                        ),
                        Container(
                          height: 32,
                          width: 56,
                          padding: const EdgeInsets.only(left: 8, bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color(0xffd9d9d9),
                            ),
                          ),
                          child: TextField(
                            controller: productDepth,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const Text(
                          'cm × 高さ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff4b4b4b),
                          ),
                        ),
                        Container(
                          height: 32,
                          width: 56,
                          padding: const EdgeInsets.only(left: 8, bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color(0xffd9d9d9),
                            ),
                          ),
                          child: TextField(
                            controller: productHeight,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const Text(
                          'cm',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff4b4b4b),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Divider(),
                    const SizedBox(height: 4),
                    const Text(
                      '商品説明',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff686868),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: const Color(0xffd9d9d9),
                        ),
                      ),
                      child: TextField(
                        controller: productDescription,
                        decoration: const InputDecoration(
                          hintText: '商品について詳しく説明しましょう',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xffd9d9d9),
                          ),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        minLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // 取引依頼ボタン
              Container(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    if (isInputCompleted.value) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: screenSize.height - 64,
                            //child: const TradeSuccessSheet(),
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffffffff),
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: isInputCompleted.value
                            ? const Color(0xff424242)
                            : const Color(0xffd9d9d9),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Container(
                    height: 48,
                    width: screenSize.width - 48,
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    alignment: Alignment.center,
                    child: Text(
                      '次へ',
                      style: TextStyle(
                        fontSize: 14,
                        color: isInputCompleted.value
                            ? const Color(0xff424242)
                            : const Color(0xffd9d9d9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
