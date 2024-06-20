import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/constants.dart';
import '../common/furniture_cell.dart';

class SearchResultView extends HookConsumerWidget {
  final String searchKeyword;
  const SearchResultView({
    super.key,
    required this.searchKeyword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isSoldOnly = useState(false);

    const prefecturesIndex = 12;
    
    // final searchResultList = [
    //   Row(
    //     children: [
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: false),
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: true),
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: false),
    //     ],
    //   ),
    //   Row(
    //     children: [
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: true),
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: false),
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: false),
    //     ],
    //   ),
    //   Row(
    //     children: [
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: false),
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: true),
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: true),
    //     ],
    //   ),
    //   Row(
    //     children: [
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: true),
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: false),
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: true),
    //     ],
    //   ),
    //   Row(
    //     children: [
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: false),
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: true),
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: false),
    //     ],
    //   ),
    //   Row(
    //     children: [
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: true),
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: false),
    //       FurnitureCell(
    //           prefecture: prefectures[prefecturesIndex], isSold: false),
    //     ],
    //   ),
    // ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffffff),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(0);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Container(
              height: 32,
              width: screenSize.width - 80,
              padding: const EdgeInsets.only(left: 8),
              color: const Color(0xffd9d9d9),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    searchKeyword,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4b4b4b),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 88,
            padding: const EdgeInsets.only(left: 8, right: 8),
            color: const Color(0xffffffff),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_alt_outlined),
                    ),
                    const SizedBox(width: 8),
                    // 受け渡しエリアで絞るボタン
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Ink(
                          height: 32,
                          width: 136,
                          padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffd9d9d9)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                '受け渡しエリア',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 色で絞るボタン
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Ink(
                          height: 32,
                          width: 64,
                          padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffd9d9d9)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                '色',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // サイズで絞るボタン
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        child: Ink(
                          height: 32,
                          width: 96,
                          padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffd9d9d9)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'サイズ',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 56),
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: Checkbox(
                        value: isSoldOnly.value,
                        onChanged: (value) {
                          isSoldOnly.value = value ?? false;
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '販売中の商品のみを表示',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff4b4b4b),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: screenSize.height - 204,
            padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
            color: const Color(0xffffffff),
            child: SingleChildScrollView(
              child: Column(children: []),
            ),
          ),
        ],
      ),
    );
  }
}
