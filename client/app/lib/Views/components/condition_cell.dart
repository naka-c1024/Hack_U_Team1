import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/constants.dart';
import 'package:app/Usecases/provider.dart';

class ConditionCell extends HookConsumerWidget {
  final int conditionIndex;
  const ConditionCell({
    required this.conditionIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(conditionProvider);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(conditionProvider.notifier).state = conditionIndex;
          Navigator.of(context).pop(1);
        },
        child: Ink(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                conditions[conditionIndex],
                style: const TextStyle(fontSize: 14),
              ),
              selectedIndex == conditionIndex
                  ? const Icon(Icons.check)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
