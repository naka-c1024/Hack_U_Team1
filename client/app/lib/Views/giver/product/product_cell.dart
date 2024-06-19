import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../Domain/furniture.dart';
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
                    // TODO: ここに写真が入る
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      color: const Color(0xffd9d9d9),
                      borderRadius: BorderRadius.circular(5),
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
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 4, right: 8),
                            child: Icon(
                              Icons.favorite_outline_outlined,
                              color: Color(0xff636363),
                            ),
                          ),
                          Text(
                            'いいね 8件',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff636363),
                            ),
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
