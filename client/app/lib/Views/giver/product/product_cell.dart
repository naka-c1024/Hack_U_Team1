import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../Domain/furniture.dart';
import '../../../Usecases/provider.dart';
import '../../common/furniture_detail_view.dart';

class ProductCell extends HookConsumerWidget {
  final Furniture furniture;
  final bool isCompleted;
  const ProductCell({
    required this.furniture,
    required this.isCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteCountState =
        ref.watch(favoriteCountProvider(furniture.furnitureId));

    // 画面を更新
    Future<void> reloadFavoriteCount() {
      // ignore: unused_result
      ref.refresh(favoriteCountProvider(furniture.furnitureId));
      return ref.read(favoriteCountProvider(furniture.furnitureId).future);
    }

    useEffect((){
      reloadFavoriteCount();
      return null;
    },[]);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // 家具の詳細ページへ
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FurnitureDetailView(
                    furniture: furniture,
                    isMyProduct: true,
                    isHiddenButton: isCompleted,
                  ),
                ),
              );
            },
            child: Ink(
              height: 88,
              color: const Color(0xffffffff),
              child: Row(
                children: [
                  Container(
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      color: const Color(0xffd9d9d9),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Center(
                        child: Image.memory(furniture.image!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        furniture.productName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4, right: 8),
                            child: Icon(
                              Icons.favorite_outline_outlined,
                              color: Color(0xff636363),
                            ),
                          ),
                          favoriteCountState.when(
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, __) => const Text(
                              'いいね 0件',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff636363),
                              ),
                            ),
                            skipLoadingOnRefresh: false,
                            data: (data) {
                              return Text(
                                'いいね ${data.toString()}件',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff636363),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 24,
                    color: Color(0xff575757),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
