import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Domain/constants.dart';
import '../../../Domain/furniture.dart';
import '../../../Domain/theme_color.dart';
import '../../../Usecases/provider.dart';
import 'color_sheet.dart';
import 'category_sheet.dart';
import 'condition_sheet.dart';
import 'register_trade_sheet.dart';
import 'register_picture_sheet.dart';

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

    final userName = useState('');
    final area = useState(0);
    final future = useMemoized(SharedPreferences.getInstance);
    final snapshot = useFuture(future, initialData: null);

    useEffect(() {
      final preferences = snapshot.data;
      if (preferences == null) {
        return null;
      }
      userName.value = preferences.getString('userName') ?? '';
      area.value = preferences.getInt('address') ?? 0;
      return null;
    }, [snapshot.data]);

    final ValueNotifier<String?> imagePath = useState(null);
    final productName = useTextEditingController(text: '');
    final categoryIndex = ref.watch(categoryProvider);
    final colorIndex = ref.watch(colorProvider);
    final conditionIndex = ref.watch(conditionProvider);
    final width = ref.watch(widthProvider);
    final depth = ref.watch(depthProvider);
    final height = ref.watch(heightProvider);
    final productDescription = useTextEditingController(text: '');
    final isInputCompleted = useState(false);

    final description = ref.watch(descriptionProvider.notifier).state;

    useEffect(() {
      // この画面に戻ってきた時に商品説明を更新
      Future.microtask(() => {
            if (description != null)
              {
                productName.text = description.productName,
                productDescription.text = description.description,
                ref.read(categoryProvider.notifier).state =
                    description.category,
                ref.read(colorProvider.notifier).state = description.color,
              }
          });
      return null;
    }, [description]);

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

    Future<String?> rotateAndSaveImage(String path) async {
      File originalFile = File(path);
      img.Image image = img.decodeImage(await originalFile.readAsBytes())!;
      // img.Image rotated = img.copyRotate(image, angle: -90);

      Directory dir = await getApplicationDocumentsDirectory();
      String imagePath = '${dir.path}/rotated_image.jpg';
      File(imagePath).writeAsBytesSync(img.encodeJpg(image));

      return imagePath;
    }

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
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
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
                      ref.read(categoryProvider.notifier).state = -1;
                      ref.read(colorProvider.notifier).state = -1;
                      ref.read(conditionProvider.notifier).state = -1;
                      ref.read(heightProvider.notifier).state = null;
                      ref.read(widthProvider.notifier).state = null;
                      ref.read(depthProvider.notifier).state = null;
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
                      color: ThemeColors.keyGreen,
                    ),
                  ),
                  Container(
                    height: 2,
                    width: 24,
                    color: ThemeColors.bgGray1,
                  ),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeColors.bgGray1,
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
                  top: 16,
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
                            final FocusScopeNode currentScope =
                                FocusScope.of(context);
                            if (!currentScope.hasPrimaryFocus &&
                                currentScope.hasFocus) {
                              FocusManager.instance.primaryFocus!.unfocus();
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Scaffold(
                                    body: Stack(
                                      children: [
                                        Container(
                                          height: screenSize.height,
                                          width: screenSize.width,
                                          color: ThemeColors.lineGray2,
                                        ),
                                        Positioned(
                                          top: 64,
                                          child: SizedBox(
                                            height: screenSize.height - 64,
                                            width: screenSize.width,
                                            child: RegisterPictureSheet(
                                              cameraController:
                                                  cameraController,
                                              imagePath: imagePath,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: Ink(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: ThemeColors.bgGray1,
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
                          color: ThemeColors.bgGray1,
                        ),
                      ),
                      child: TextField(
                        focusNode: focus,
                        controller: productName,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(40),
                        ],
                        decoration: const InputDecoration(
                          hintText: '必須 (40文字まで)',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: ThemeColors.bgGray1,
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
                              final FocusScopeNode currentScope =
                                  FocusScope.of(context);
                              if (!currentScope.hasPrimaryFocus &&
                                  currentScope.hasFocus) {
                                FocusManager.instance.primaryFocus!.unfocus();
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Scaffold(
                                      body: Stack(
                                        children: [
                                          Container(
                                            height: screenSize.height,
                                            width: screenSize.width,
                                            color: ThemeColors.lineGray2,
                                          ),
                                          Positioned(
                                            top: 64,
                                            child: SizedBox(
                                              height: screenSize.height - 64,
                                              width: screenSize.width,
                                              child: const CategorySheet(),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
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
                                            color: ThemeColors.bgGray1,
                                          ),
                                        )
                                      : Text(
                                          categorys[categoryIndex],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: ThemeColors.textGray1,
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
                              final FocusScopeNode currentScope =
                                  FocusScope.of(context);
                              if (!currentScope.hasPrimaryFocus &&
                                  currentScope.hasFocus) {
                                FocusManager.instance.primaryFocus!.unfocus();
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Scaffold(
                                      body: Stack(
                                        children: [
                                          Container(
                                            height: screenSize.height,
                                            width: screenSize.width,
                                            color: ThemeColors.lineGray2,
                                          ),
                                          Positioned(
                                            top: 64,
                                            child: SizedBox(
                                              height: screenSize.height - 64,
                                              width: screenSize.width,
                                              child: const ConditionSheet(),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
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
                                            color: ThemeColors.bgGray1,
                                          ),
                                        )
                                      : Text(
                                          conditions[conditionIndex],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: ThemeColors.textGray1,
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
                              final FocusScopeNode currentScope =
                                  FocusScope.of(context);
                              if (!currentScope.hasPrimaryFocus &&
                                  currentScope.hasFocus) {
                                FocusManager.instance.primaryFocus!.unfocus();
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Scaffold(
                                      body: Stack(
                                        children: [
                                          Container(
                                            height: screenSize.height,
                                            width: screenSize.width,
                                            color: ThemeColors.lineGray2,
                                          ),
                                          Positioned(
                                            top: 64,
                                            child: SizedBox(
                                              height: screenSize.height - 64,
                                              width: screenSize.width,
                                              child: const ColorSheet(),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
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
                                            color: ThemeColors.bgGray1,
                                          ),
                                        )
                                      : Text(
                                          colors[colorIndex],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: ThemeColors.textGray1,
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
                    Row(
                      children: [
                        const Text(
                          'サイズ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff686868),
                          ),
                        ),
                        const Spacer(),
                        width != null && depth != null && height != null
                            ? Text(
                                '幅 ${width.toString()} cm × 奥行き ${width.toString()} cm × 高さ ${height.toString()} cm',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff4b4b4b),
                                ),
                              )
                            : const Text(
                                '写真撮影画面からサイズを計測してください',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff4b4b4b),
                                ),
                              ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      '商品説明',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff686868),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: ThemeColors.bgGray1,
                        ),
                      ),
                      child: TextField(
                        controller: productDescription,
                        decoration: const InputDecoration(
                          hintText: '商品について詳しく説明しましょう',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: ThemeColors.bgGray1,
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
              // 取引依頼ボタン
              Container(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () async {
                    final FocusScopeNode currentScope = FocusScope.of(context);
                    if (!currentScope.hasPrimaryFocus &&
                        currentScope.hasFocus) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    }
                    if (isInputCompleted.value) {
                      final furniture = Furniture(
                        productName: productName.text,
                        imagePath: await rotateAndSaveImage(imagePath.value!),
                        description: productDescription.text,
                        height: (height ?? 0).toDouble(),
                        width: (width ?? 0).toDouble(),
                        depth: (depth ?? 0).toDouble(),
                        category: categoryIndex,
                        color: colorIndex,
                        condition: conditionIndex,
                        userName: userName.value,
                        area: area.value,
                        tradePlace: '',
                        isSold: false,
                        isFavorite: false,
                      );
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(
                              body: Stack(
                                children: [
                                  Container(
                                    height: screenSize.height,
                                    width: screenSize.width,
                                    color: ThemeColors.lineGray2,
                                  ),
                                  Positioned(
                                    top: 64,
                                    child: SizedBox(
                                      height: screenSize.height - 64,
                                      width: screenSize.width,
                                      child: RegisterTradeSheet(
                                          furniture: furniture),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
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
                            ? ThemeColors.keyGreen
                            : ThemeColors.bgGray2,
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
                        fontSize: 16,
                        color: isInputCompleted.value
                            ? ThemeColors.keyGreen
                            : ThemeColors.bgGray2,
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
