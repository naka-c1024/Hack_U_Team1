import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Domain/furniture.dart';
import '../Domain/trade.dart';
import 'furniture_api.dart';
import 'trade_api.dart';

// ユーザーIDを保持
final userIdProvider = StateProvider((ref) => -1);

// 選択したカテゴリをインデックスで保持
final categoryProvider = StateProvider((ref) => -1);

// 選択したカラーをインデックスで保持
final colorProvider = StateProvider((ref) => -1);

// 選択した商品の状態をインデックスで保持
final conditionProvider = StateProvider((ref) => -1);

// 家具リスト取得APIの状態を管理
final furnitureListProvider = FutureProvider<List<Furniture>>((ref) async {
  final userId = ref.read(userIdProvider);
  return getFurnitureList(userId, null);
});

// 取引リスト取得APIの状態を管理
final tradeListProvider = FutureProvider<List<Trade>>((ref) async {
  final userId = ref.read(userIdProvider);
  return getTradeList(userId);
});