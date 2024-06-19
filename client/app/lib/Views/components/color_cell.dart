import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/constants.dart';
import 'package:app/Usecases/provider.dart';

class ColorCell extends HookConsumerWidget {
  final int colorIndex;
  final bool isSheet;

  const ColorCell({
    required this.colorIndex,
    this.isSheet = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(colorProvider);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(colorProvider.notifier).state = colorIndex;
          if (isSheet) {
            Navigator.of(context).pop(1);
          }
        },
        child: Ink(
          width: 88,
          child: Column(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: colorCodes[colorIndex],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorIndex == 0
                        ? const Color(0xff000000)
                        : colorCodes[colorIndex],
                  ),
                ),
                child: selectedIndex == colorIndex
                    ? Icon(
                        Icons.check,
                        size: 40,
                        color: colorIndex == 0
                            ? const Color(0xff000000)
                            : const Color(0xffffffff),
                      )
                    : const SizedBox(),
              ),
              const SizedBox(height: 8),
              Text(
                colors[colorIndex],
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
