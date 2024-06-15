import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app/Views/components/todo_cell.dart';

class TodoListView extends HookConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        backgroundColor: const Color(0xffffffff),
        automaticallyImplyLeading: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'やることリスト',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: screenSize.height - 80,
        color: const Color(0xffffffff),
        child: const SingleChildScrollView(
          padding: EdgeInsets.only(left: 16, top: 40,right: 16),
          child: Column(
            children: [
              Divider(),
              TodoCell(),
              TodoCell(),
              TodoCell(),
            ],
          ),
        ),
      ),
    );
  }
}
