import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/theme_color.dart';

class MyPageCell extends HookConsumerWidget {
  final IconData menuIcon;
  final String menuText;
  const MyPageCell({
    required this.menuIcon,
    required this.menuText,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Ink(
          height: 80,
          width: (screenSize.width - 64) / 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: ThemeColors.lineGray1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                menuIcon,
                size: 32,
                color: ThemeColors.black,
              ),
              const SizedBox(height: 8),
              Text(
                menuText,
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
