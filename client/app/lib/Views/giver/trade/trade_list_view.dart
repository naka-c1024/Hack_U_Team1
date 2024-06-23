import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Domain/trade.dart';
import '../../../Usecases/provider.dart';
import 'trade_cell.dart';

class TradeListView extends HookConsumerWidget {
  final List<Trade> tradeList;
  const TradeListView({
    required this.tradeList,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 購入を承認したtradeIdを読み込む
    final future = useMemoized(SharedPreferences.getInstance);
    final snapshot = useFuture(future, initialData: null);
    ValueNotifier<List<String>> tradingIdList = useState([]);
    useEffect(() {
      final preferences = snapshot.data;
      if (preferences == null) {
        return null;
      }
      tradingIdList.value = preferences.getStringList('tradingIdList') ?? [];
      return null;
    }, [tradeList]);
    
    // 取引内容を表示
    final userId = ref.read(userIdProvider);
    ValueNotifier<List<Widget>> tradeCellList = useState([]);
    useEffect(() {
      tradeCellList.value = [];
      for (Trade trade in tradeList) {
        // 自分が出品者で取引が完了していないものだけ表示
        if (trade.giverId == userId && (!trade.giverApproval || !trade.receiverApproval ) ) {
          tradeCellList.value.add(
            TradeCell(
              trade: trade,
              isTrading: tradingIdList.value.contains(trade.tradeId.toString()),
            ),
          );
        }
      }
      if (tradeCellList.value.isNotEmpty){
        tradeCellList.value.insert(0,const Divider());
      }
      return null;
    }, [tradeList,tradingIdList]);

    return Container(
      color: const Color(0xffffffff),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            children: tradeCellList.value,
          ),
        ),
      ),
    );
  }
}
