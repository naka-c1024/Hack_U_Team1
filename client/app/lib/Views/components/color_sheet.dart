import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/Views/components/color_cell.dart';

class ColorSheet extends HookConsumerWidget {
  const ColorSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                'カラー',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColorCell(colorIndex: 0, isSheet: true),
                    ColorCell(colorIndex: 1, isSheet: true),
                    ColorCell(colorIndex: 2, isSheet: true),
                    ColorCell(colorIndex: 3, isSheet: true),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColorCell(colorIndex: 4, isSheet: true),
                    ColorCell(colorIndex: 5, isSheet: true),
                    ColorCell(colorIndex: 6, isSheet: true),
                    ColorCell(colorIndex: 7, isSheet: true),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColorCell(colorIndex: 8, isSheet: true),
                    ColorCell(colorIndex: 9, isSheet: true),
                    ColorCell(colorIndex: 10, isSheet: true),
                    ColorCell(colorIndex: 11, isSheet: true),
                  ],
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
