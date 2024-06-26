import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/constants.dart';
import '../../Domain/furniture.dart';
import '../../Domain/theme_color.dart';
import '../../Usecases/provider.dart';
import '../../Usecases/furniture_api.dart';
import '../../Usecases/favorite_api.dart';
import 'error_dialog.dart';
import 'trade_adjust_sheet.dart';

class FurnitureDetailView extends HookConsumerWidget {
  final Furniture furniture;
  final bool isMyProduct;
  final bool isHiddenButton;
  const FurnitureDetailView({
    required this.furniture,
    required this.isMyProduct,
    required this.isHiddenButton,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isFavorite = useState(furniture.isFavorite);
    final userId = ref.read(userIdProvider);

    // 画面を更新
    Future<void> reloadFurnitureList() {
      // ignore: unused_result
      ref.refresh(furnitureListProvider);
      return ref.read(furnitureListProvider.future);
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffffffff),
      ),
      body: Column(
        children: [
          Container(
            height: screenSize.height - 48,
            color: const Color(0xffffffff),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 商品画像
                  Stack(
                    children: [
                      Container(
                        height: screenSize.width,
                        width: screenSize.width,
                        color: ThemeColors.bgGray1,
                        child: Center(
                          child: Image.memory(furniture.image!),
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(left: 8),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xffffffff),
                          shadows: [
                            BoxShadow(color: Color(0xff000000), blurRadius: 8)
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(0);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              furniture.productName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // いいねボタン
                            ElevatedButton(
                              onPressed: () {
                                isFavorite.value = !isFavorite.value;
                                if (furniture.furnitureId == null) return;
                                if (isFavorite.value) {
                                  addFavorite(userId, furniture.furnitureId!);
                                } else {
                                  deleteFavorite(
                                      userId, furniture.furnitureId!);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffffffff),
                                foregroundColor: isFavorite.value
                                    ? const Color(0xff474747)
                                    : const Color(0xff858585),
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Container(
                                height: 24,
                                width: 72,
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    isFavorite.value
                                        ? const Icon(Icons.favorite, size: 16)
                                        : const Icon(Icons.favorite_border,
                                            size: 16),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 2),
                                      child: Text('いいね',
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '商品説明',
                          style: TextStyle(
                            color: Color(0xff6a6a6a),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          furniture.description,
                          style: const TextStyle(
                            color: ThemeColors.textGray1,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          '引き渡しについて',
                          style: TextStyle(
                            color: Color(0xff6a6a6a),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Divider(),
                        const SizedBox(height: 4),
                        // 引き渡し期間
                        Row(
                          children: [
                            const SizedBox(
                              width: 96,
                              child: Text(
                                '可能期間',
                                style: TextStyle(
                                  color: ThemeColors.textGray1,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              (furniture.startDate == null &&
                                      furniture.endDate == null)
                                  ? '無期限'
                                  : furniture.startDate == null
                                      ? ' 〜 ${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.endDate!)}'
                                      : furniture.endDate == null
                                          ? '${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.startDate!)} 〜 '
                                          : '${DateFormat('yyyy年M月d日(E)', 'ja').format(furniture.startDate!)} 〜 ${DateFormat('yyyy年MM月dd日(E)', 'ja').format(furniture.endDate!)}',
                              style: const TextStyle(
                                color: ThemeColors.textGray1,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 引き渡し場所
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 96,
                              child: Text(
                                '場所',
                                style: TextStyle(
                                  color: ThemeColors.textGray1,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  furniture.tradePlace,
                                  style: const TextStyle(
                                    color: ThemeColors.textGray1,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(
                                    'assets/images/trade_map.png',
                                    width: 256,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Divider(),
                        const SizedBox(height: 24),
                        const Text(
                          '商品の情報',
                          style: TextStyle(
                            color: Color(0xff6a6a6a),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Divider(),
                        const SizedBox(height: 4),
                        // サイズ
                        Row(
                          children: [
                            const SizedBox(
                              width: 96,
                              child: Text(
                                'サイズ',
                                style: TextStyle(
                                  color: ThemeColors.textGray1,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '幅${furniture.width.toInt()}cm×奥行き${furniture.depth.toInt()}cm×高さ${furniture.height.toInt()}cm',
                              style: const TextStyle(
                                color: ThemeColors.textGray1,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // カテゴリ
                        Row(
                          children: [
                            const SizedBox(
                              width: 96,
                              child: Text(
                                'カテゴリ',
                                style: TextStyle(
                                  color: ThemeColors.textGray1,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              categorys[furniture.category],
                              style: const TextStyle(
                                color: ThemeColors.textGray1,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 色味
                        Row(
                          children: [
                            const SizedBox(
                              width: 96,
                              child: Text(
                                '色味',
                                style: TextStyle(
                                  color: ThemeColors.textGray1,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                color: colorCodes[furniture.color],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              colors[furniture.color],
                              style: const TextStyle(
                                color: ThemeColors.textGray1,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 商品の状態
                        Row(
                          children: [
                            const SizedBox(
                              width: 96,
                              child: Text(
                                '商品の状態',
                                style: TextStyle(
                                  color: ThemeColors.textGray1,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              conditions[furniture.condition],
                              style: const TextStyle(
                                color: ThemeColors.textGray1,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Divider(),
                        const SizedBox(height: 24),
                        const Text(
                          '出品者',
                          style: TextStyle(
                            color: Color(0xff6a6a6a),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Divider(),
                        // 出品者情報
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            ClipOval(
                              child: Image.asset(
                                'assets/images/user_icon_2.png',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  furniture.userName,
                                  style: const TextStyle(
                                    color: ThemeColors.textGray1,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  prefectures[furniture.area],
                                  style: const TextStyle(
                                    color: ThemeColors.textGray1,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 24),
                        (isMyProduct && !isHiddenButton)
                            ? Column(
                                children: [
                                  // 商品を編集するボタン
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xffffffff),
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: ThemeColors.keyRed,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Container(
                                      height: 48,
                                      width: screenSize.width - 48,
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '商品を編集する',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: ThemeColors.keyRed,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // 商品を削除するボタン
                                  ElevatedButton(
                                    onPressed: () {
                                      if (furniture.furnitureId != null) {
                                        final futureResult = deleteFurniture(
                                            furniture.furnitureId!);
                                        futureResult.then((result) {
                                          Navigator.of(context).pop(0);
                                        }).catchError((error) {
                                          showErrorDialog(context, error.toString());
                                        });
                                      }
                                      reloadFurnitureList();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ThemeColors.keyRed,
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
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '商品を削除する',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xffffffff),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            // 取引依頼ボタン
                            : (!isMyProduct && !isHiddenButton)
                                ? ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                            height: screenSize.height - 64,
                                            child: TradeAdjustSheet(
                                                furniture: furniture),
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ThemeColors.keyGreen,
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
                                      margin: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '取引をお願いする',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xffffffff),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                        const SizedBox(height: 64),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
