import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/chemist_shop_notifier.dart';
import '../models/chemist_shop.dart';

final chemistShopNotifierProvider =
    StateNotifierProvider<ChemistShopNotifier, List<ChemistShop>>(
  (ref) => ChemistShopNotifier(),
);

final filteredChemistShopsProvider =
    StateProvider<List<ChemistShop>>((ref) {
  return ref.watch(chemistShopNotifierProvider);
});

final chemistShopByIdProvider =
    Provider.family<ChemistShop?, String>((ref, id) {
  final shops = ref.watch(chemistShopNotifierProvider);
  try {
    return shops.firstWhere((s) => s.id == id);
  } catch (e) {
    return null;
  }
});
