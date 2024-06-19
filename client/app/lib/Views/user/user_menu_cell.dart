import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserMenuCell extends HookConsumerWidget {
  final IconData menuIcon;
  final String menuText;
  const UserMenuCell({
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
            border: Border.all(color: const Color(0xffd9d9d9)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                menuIcon,
                size: 32,
                color: const Color(0xff424242),
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
