import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/condition_cell.dart';

class ConditionSheet extends HookConsumerWidget {
  const ConditionSheet({
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
                '商品の状態',
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
                ConditionCell(conditionIndex: 0),
                Divider(),
                ConditionCell(conditionIndex: 1),
                Divider(),
                ConditionCell(conditionIndex: 2),
                Divider(),
                ConditionCell(conditionIndex: 3),
                Divider(),
                ConditionCell(conditionIndex: 4),
                Divider(),
                ConditionCell(conditionIndex: 5),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
