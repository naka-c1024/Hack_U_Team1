import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Domain/description.dart';
import '../Domain/furniture.dart';
import '../Domain/trade.dart';
import 'furniture_api.dart';
import 'favorite_api.dart';
import 'trade_api.dart';

// ユーザーIDを保持
final userIdProvider = StateProvider((ref) => -1);

// ユーザーネームを保持
final userNameProvider = StateProvider((ref) => '');

// 選択したカテゴリをインデックスで保持
final categoryProvider = StateProvider((ref) => -1);

// 選択したカラーをインデックスで保持
final colorProvider = StateProvider((ref) => -1);

// 選択したカラーを複数インデックスで保持
final colorListProvider = StateProvider((ref) => []);

// 選択した商品の状態をインデックスで保持
final conditionProvider = StateProvider((ref) => -1);

// 計測した高さを保持
final heightProvider = StateProvider<int?>((ref) => null);

// 計測した幅を保持
final widthProvider = StateProvider<int?>((ref) => null);

// 計測した奥行きを保持
final depthProvider = StateProvider<int?>((ref) => null);

// 家具リスト取得APIの状態を管理
final furnitureListProvider = FutureProvider<List<Furniture>>((ref) async {
  final userId = ref.read(userIdProvider);
  return getFurnitureList(userId, null, null);
});

//　出品した商品取得APIの状態を取得
final myProductListProvider = FutureProvider<List<Furniture>>((ref) async {
  final userId = ref.read(userIdProvider);
  return getMyProductList(userId);
});

// 取引リスト取得APIの状態を管理
final tradeListProvider = FutureProvider<List<Trade>>((ref) async {
  final userId = ref.read(userIdProvider);
  return getTradeList(userId);
});

// いいね数取得APIの状態を管理
final favoriteCountProvider =
    FutureProvider.family<int, int?>((ref, furnitureId) async {
  return getFavoriteCount(furnitureId!);
});

// AIが返してくれた家具の説明を保持
final descriptionProvider = StateProvider.autoDispose<Description?>((ref) => null);

// AIが返してくれたおすすめ家具の理由を保持
final reasonProvider = StateProvider<String?>((ref) => null);

// AIが返してくれたおすすめ家具のリストを保持 (キーワード検索結果もこれで管理)
final searchResultProvider = StateProvider.autoDispose<List<Furniture>>((ref) => []);
