import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final controller = useTabController(initialLength:3);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
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
                        ).whenComplete(() {
                          controller.index = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: SizedBox(
                        width: screenSize.width - 96,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/camera_icon.png',
                              width: 24,
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              '出品する',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          bottom: TabBar(
            controller: controller,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2.0,
            tabs: const [
              Tab(
                child: Text(
                  '   取引中   ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '   出品中   ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              Tab(
                child: Text(
                  ' 譲渡済み ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
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
