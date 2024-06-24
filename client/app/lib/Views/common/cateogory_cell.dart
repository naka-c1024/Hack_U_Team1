import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/constants.dart';
import '../../Usecases/provider.dart';

class CategoryCell extends HookConsumerWidget {
  final int categoryIndex;
  final bool isSheet;
  final ValueNotifier<int>? searchPictureProcess;
  const CategoryCell({
    required this.categoryIndex,
    this.isSheet = false,
    this.searchPictureProcess,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(categoryProvider);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(categoryProvider.notifier).state = categoryIndex;
          if (isSheet) {
            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.of(context).pop(1);
            });
          }
          if (searchPictureProcess != null){
            Future.delayed(const Duration(milliseconds: 300), () {
              searchPictureProcess!.value = 1;
            });
          }
        },
        child: Ink(
          width: 88,
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: selectedIndex == categoryIndex
                          ? const Color(0xfff4f4f4)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  selectedIndex == categoryIndex
                      ? Positioned(
                          top: 16,
                          left: -4,
                          child: Container(
                            transform: Matrix4.rotationZ(-15 * pi / 180),
                            child: Image.asset(
                              '/Users/ibuki/StudioProjects/Hack_U_Team1/client/app/assets/images/category_$categoryIndex.png',
                              height: 72,
                              width: 72,
                            ),
                          ),
                        )
                      : Image.asset(
                          '/Users/ibuki/StudioProjects/Hack_U_Team1/client/app/assets/images/category_$categoryIndex.png',
                          height: 72,
                          width: 72,
                        ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                categorys[categoryIndex],
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
