import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Domain/trade.dart';
import '../../Usecases/provider.dart';
import 'trade/trade_list_view.dart';
import 'product/product_list_view.dart';
import 'register/register_product_sheet.dart';

class RegisterProductView extends HookConsumerWidget {
  final List<Trade> tradeList;
  final ValueNotifier<CameraController?> cameraController;
  const RegisterProductView({
    required this.tradeList,
    required this.cameraController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 8,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xffffffff),
          title: Column(
            children: [
              Container(
                height: 56,
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 出品用に初期化
                        ref.read(categoryProvider.notifier).state = -1;
                        ref.read(colorProvider.notifier).state = -1;
                        ref.read(conditionProvider.notifier).state = -1;
                        // 出品画面へ
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: screenSize.height - 64,
                              child: RegisterProductSheet(
                                  cameraController: cameraController),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffffffff),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: SizedBox(
                        width: screenSize.width - 136,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_camera_outlined),
                            SizedBox(width: 8),
                            Text('出品する'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  '取引中',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '出品中',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '譲渡済み',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TradeListView(tradeList: tradeList),
            const ProductListView(isCompleted: false),
            const ProductListView(isCompleted: true),
          ],
        ),
      ),
    );
  }
}
