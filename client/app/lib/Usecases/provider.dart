import 'package:hooks_riverpod/hooks_riverpod.dart';

// 選択したカテゴリをインデックスで保持
final categoryProvider = StateProvider((ref) => -1);

// 選択したカラーをインデックスで保持
final colorProvider = StateProvider((ref) => -1);

// 選択した商品の状態をインデックスで保持
final conditionProvider = StateProvider((ref) => -1);
