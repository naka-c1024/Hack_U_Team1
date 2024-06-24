import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SizeFilterMenu extends HookConsumerWidget {
  final TextEditingController maxWidth;
  final TextEditingController maxDepth;
  final TextEditingController maxHeight;
  final TextEditingController minWidth;
  final TextEditingController minDepth;
  final TextEditingController minHeight;
  const SizeFilterMenu({
    required this.maxWidth,
    required this.maxDepth,
    required this.maxHeight,
    required this.minWidth,
    required this.minDepth,
    required this.minHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Container(
        color: const Color(0xffffffff),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'サイズ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xff131313),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '上限',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xff4b4b4b),
              ),
            ),
            const SizedBox(height: 16),
            // 上限入力フォーム
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  children: [
                    Text(
                      ' 幅',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff4b4b4b),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
                Container(
                  height: 32,
                  width: 40,
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: TextField(
                    controller: maxWidth,
                    style: TextStyle(
                      fontSize: 14,
                      color: maxWidth.text == '999'
                          ? const Color(0xff838383)
                          : const Color(0xff000000),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '999',
                      hintStyle: TextStyle(color: Color(0xff838383)),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Column(
                  children: [
                    Text(
                      ' cm   ×   奥行き ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff4b4b4b),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
                Container(
                  height: 32,
                  width: 40,
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: TextField(
                    controller: maxDepth,
                    style: TextStyle(
                      fontSize: 14,
                      color: maxWidth.text == '999'
                          ? const Color(0xff838383)
                          : const Color(0xff000000),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '999',
                      hintStyle: TextStyle(color: Color(0xff838383)),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Column(
                  children: [
                    Text(
                      ' cm   ×   高さ ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff4b4b4b),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
                Container(
                  height: 32,
                  width: 40,
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: TextField(
                    controller: maxHeight,
                    style: TextStyle(
                      fontSize: 14,
                      color: maxWidth.text == '999'
                          ? const Color(0xff838383)
                          : const Color(0xff000000),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '999',
                      hintStyle: TextStyle(color: Color(0xff838383)),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Column(
                  children: [
                    Text(
                      ' cm  ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff4b4b4b),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              '下限',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xff4b4b4b),
              ),
            ),
            const SizedBox(height: 16),
            // 下限入力フォーム
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  children: [
                    Text(
                      ' 幅',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff4b4b4b),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
                Container(
                  height: 32,
                  width: 40,
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: TextField(
                    controller: minWidth,
                    style: TextStyle(
                      fontSize: 14,
                      color: minWidth.text == '0'
                          ? const Color(0xff838383)
                          : const Color(0xff000000),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TextStyle(color: Color(0xff838383)),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Column(
                  children: [
                    Text(
                      ' cm   ×   奥行き ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff4b4b4b),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
                Container(
                  height: 32,
                  width: 40,
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: TextField(
                    controller: minDepth,
                    style: TextStyle(
                      fontSize: 14,
                      color: minWidth.text == '0'
                          ? const Color(0xff838383)
                          : const Color(0xff000000),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TextStyle(color: Color(0xff838383)),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Column(
                  children: [
                    Text(
                      ' cm   ×   高さ ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff4b4b4b),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
                Container(
                  height: 32,
                  width: 40,
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: TextField(
                    controller: minHeight,
                    style: TextStyle(
                      fontSize: 14,
                      color: minWidth.text == '0'
                          ? const Color(0xff838383)
                          : const Color(0xff000000),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TextStyle(color: Color(0xff838383)),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Column(
                  children: [
                    Text(
                      ' cm  ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff4b4b4b),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
