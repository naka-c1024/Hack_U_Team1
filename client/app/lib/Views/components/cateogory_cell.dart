import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/constants.dart';
import 'package:app/Usecases/provider.dart';

class CategoryCell extends HookConsumerWidget {
  final int categoryIndex;
  final bool isSheet;

  const CategoryCell({
    required this.categoryIndex,
    this.isSheet = false,
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
            Navigator.of(context).pop(1);
          }
        },
        child: Ink(
          width: 88,
          child: Column(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: selectedIndex == categoryIndex
                      ? const Color(0xff717171)
                      : const Color(0xffd9d9d9),
                  shape: BoxShape.circle,
                ),
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
