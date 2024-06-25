import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../Domain/furniture.dart';
import '../../../Usecases/provider.dart';
import 'product_cell.dart';

class ProductListView extends HookConsumerWidget {
  final bool isCompleted;
  const ProductListView({
    required this.isCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final productCellList = useState<List<Widget>>([]);

    final myProductState = ref.watch(myProductListProvider);

    // 画面を更新
    Future<void> reloadMyProductList() {
      // ignore: unused_result
      ref.refresh(myProductListProvider);
      return ref.read(myProductListProvider.future);
    }

    return RefreshIndicator(
        onRefresh: () => reloadMyProductList(),
        // 家具リストの取得
        child: myProductState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, __) => Center(
            child: Text('$error'),
          ),
          skipLoadingOnRefresh: false,
          data: (data) {
            // 取得したデータをWidgetに入れる
            for (Furniture furniture in data) {
              if (furniture.isSold == isCompleted) {
                productCellList.value.add(
                  ProductCell(
                    furniture: furniture,
                    isCompleted: isCompleted,
                  ),
                );
              }
            }
            if (productCellList.value.isNotEmpty) {
              productCellList.value.insert(0, const Divider());
            }

            return Container(
              height: screenSize.height,
              width: screenSize.width,
              color: const Color(0xffffffff),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: SingleChildScrollView(
                  child: Column(children: productCellList.value),
                ),
              ),
            );
          },
        ));
  }
}
