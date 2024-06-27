import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/theme_color.dart';
import '../Common/color_cell.dart';

class ColorFilterMenu extends HookConsumerWidget {
  const ColorFilterMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '色',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ThemeColors.black,
          ),
        ),
        SizedBox(height: 16),
        Column(
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColorCell(colorIndex: 0, isSheet: false),
                ColorCell(colorIndex: 1, isSheet: false),
                ColorCell(colorIndex: 2, isSheet: false),
                ColorCell(colorIndex: 3, isSheet: false),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColorCell(colorIndex: 4, isSheet: false),
                ColorCell(colorIndex: 5, isSheet: false),
                ColorCell(colorIndex: 6, isSheet: false),
                ColorCell(colorIndex: 7, isSheet: false),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ColorCell(colorIndex: 8, isSheet: false),
                ColorCell(colorIndex: 9, isSheet: false),
                ColorCell(colorIndex: 10, isSheet: false),
                ColorCell(colorIndex: 11, isSheet: false),
              ],
            ),
            SizedBox(height: 24),
          ],
        ),
      ],
    );
  }
}
