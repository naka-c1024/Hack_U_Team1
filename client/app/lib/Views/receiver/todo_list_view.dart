import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Domain/trade.dart';
import '../../Domain/theme_color.dart';
import '../../Usecases/provider.dart';
import '../common/error_dialog.dart';
import '../common/todo_cell.dart';

class TodoListView extends HookConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final userId = ref.read(userIdProvider);

    final tradeState = ref.watch(tradeListProvider);

    Future<void> reloadTradeList() {
      // ignore: unused_result
      ref.refresh(tradeListProvider);
      return ref.read(tradeListProvider.future);
    }

    // 画面を移動した時に自動で更新
    useEffect(() {
      Future.microtask(() => {reloadTradeList()});
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

    // 0 ユーザーは購入者：出品者の承認待ち
    // 1 ユーザーは出品者：取引開始前
    // 2 ユーザーは出品者または購入者：承認待ち
    // 3 相手の承認待ち
    int checkStatus(Trade trade) {
      if (userId == trade.receiverId) {
        if (!trade.giverApproval && !trade.receiverApproval) {
          return 0;
        } else if (trade.giverApproval && !trade.receiverApproval) {
          return 2;
        } else {
          return 3;
        }
      } else {
        if (tradingIdList.value.contains(trade.tradeId.toString())) {
          return 2;
        } else if (trade.giverApproval) {
          return 3;
        } else {
          return 1;
        }
      }
    }

    // 取引内容を表示
    ValueNotifier<List<Widget>> tradeCellList = useState([]);
    void createTradeCellList(List<Trade> tradeList) {
      tradeCellList.value = [];
      for (Trade trade in tradeList) {
        // 取引が完了していないものだけ表示
        if (trade.receiverId == userId) {
          if (!trade.receiverApproval) {
            tradeCellList.value.add(
              TodoCell(
                trade: trade,
                tradeStatus: checkStatus(trade),
              ),
            );
          }
        } else {
          if (trade.giverApproval ==
              tradingIdList.value.contains(trade.tradeId.toString())) {
            tradeCellList.value.add(
              TodoCell(
                trade: trade,
                tradeStatus: checkStatus(trade),
              ),
            );
          }
        }
      }
      if (tradeCellList.value.isNotEmpty) {
        tradeCellList.value.insert(0, const Divider());
      }
    }

    return Scaffold(
      appBar: AppBar(
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
        width: screenSize.width,
        color: const Color(0xffffffff),
        // 下に引っ張った時に更新
        child: RefreshIndicator(
          color: ThemeColors.keyGreen,
          onRefresh: () => reloadTradeList(),
          // 取引リストの取得
          child: tradeState.when(
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: ThemeColors.keyGreen,
              ),
            ),
            error: (error, __) => errorDialog(context,error.toString()),
            skipLoadingOnRefresh: false,
            data: (data) {
              getTradingIdList();
              createTradeCellList(data);
              return SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, top: 0, right: 16),
                child: Column(
                  children: tradeCellList.value,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
