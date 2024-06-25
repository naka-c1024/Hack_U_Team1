import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Domain/trade.dart';
import '../../../Usecases/provider.dart';
import 'trade_cell.dart';

class TradeListView extends HookConsumerWidget {
  const TradeListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeState = ref.watch(tradeListProvider);

    Future<void> reloadTradeList() {
      // ignore: unused_result
      ref.refresh(tradeListProvider);
      return ref.read(tradeListProvider.future);
    }

    // 画面を移動した時に自動で更新
    useEffect(() {
      reloadTradeList();
      return null;
    }, []);

    // 購入を承認したtradeIdを読み込む
    final future = useMemoized(SharedPreferences.getInstance);
    final snapshot = useFuture(future, initialData: null);
    ValueNotifier<List<String>> tradingIdList = useState([]);
    void getTradingIdList() {
      final preferences = snapshot.data;
      if (preferences == null) {
        return;
      }
      tradingIdList.value = preferences.getStringList('tradingIdList') ?? [];
    }

    // 取引内容を表示
    final userId = ref.read(userIdProvider);
    ValueNotifier<List<Widget>> tradeCellList = useState([]);
    void createTradeCellList(List<Trade> tradeList) {
      tradeCellList.value = [];
      for (Trade trade in tradeList) {
        // 自分が出品者で取引が完了していないものだけ表示
        if (trade.giverId == userId &&
            (!trade.giverApproval || !trade.receiverApproval)) {
          tradeCellList.value.add(
            TradeCell(
              trade: trade,
              isTrading: tradingIdList.value.contains(trade.tradeId.toString()),
            ),
          );
        }
      }
      if (tradeCellList.value.isNotEmpty) {
        tradeCellList.value.insert(0, const Divider());
      }
    }

    return Container(
      color: const Color(0xffffffff),
      // 下に引っ張った時に更新
      child: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () => reloadTradeList(),
        // 取引リストの取得
        child: tradeState.when(
          loading: () => Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
          error: (error, __) => Center(
            child: Text('$error'),
          ),
          skipLoadingOnRefresh: false,
          data: (data) {
            getTradingIdList();
            createTradeCellList(data);
            return SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: Column(
                children: tradeCellList.value,
              ),
            );
          },
        ),
      ),
    );
  }
}
