import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Domain/trade.dart';
import '../../Usecases/provider.dart';
import '../common/todo_cell.dart';

class TodoListView extends HookConsumerWidget {
  final List<Trade> tradeList;
  const TodoListView({
    required this.tradeList,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final userId = ref.read(userIdProvider);

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

    // 0 ユーザーは購入者：出品者の承認待ち
    // 1 ユーザーは出品者：取引開始前
    // 2 ユーザーは出品者または購入者：承認待ち
    int checkStatus(Trade trade) {
      if (userId == trade.receiverId) {
        if (trade.giverApproval) {
          return 2;
        } else {
          return 0;
        }
      } else {
        if (tradingIdList.value.contains(trade.tradeId.toString())) {
          return 1;
        } else {
          return 2;
        }
      }
    }

    // 取引内容を表示
    ValueNotifier<List<Widget>> tradeCellList = useState([]);
    useEffect(() {
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
          if (!trade.giverApproval || !trade.receiverApproval) {
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
      return null;
    }, [tradeList, tradingIdList]);

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, top: 40, right: 16),
          child: Column(
            children: tradeCellList.value,
          ),
        ),
      ),
    );
  }
}
