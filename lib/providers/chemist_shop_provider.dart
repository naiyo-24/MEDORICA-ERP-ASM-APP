import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/chemist_shop.dart';
import '../notifiers/chemist_shop_notifier.dart';
import '../services/chemist_shop/chemist_shop_services.dart';
import 'auth_provider.dart';

final chemistShopServicesProvider = Provider<ChemistShopServices>((ref) {
  return ChemistShopServices();
});

final chemistShopNotifierProvider =
    StateNotifierProvider<ChemistShopNotifier, ChemistShopState>((ref) {
      final notifier = ChemistShopNotifier(
        ref.read(chemistShopServicesProvider),
      );

      ref.listen(authNotifierProvider, (previous, next) {
        if (!next.isAuthenticated || next.asmId == null) {
          notifier.syncAsm(null);
          return;
        }
        notifier.syncAsm(next.asmId);
      }, fireImmediately: true);

      return notifier;
    });

final isShopsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(chemistShopNotifierProvider).isLoading;
});

final shopErrorProvider = Provider<String?>((ref) {
  return ref.watch(chemistShopNotifierProvider).error;
});

final filteredChemistShopsProvider = Provider<List<ChemistShop>>((ref) {
  return ref.watch(chemistShopNotifierProvider).shops;
});

final chemistShopByIdProvider = Provider.family<ChemistShop?, String>((
  ref,
  id,
) {
  final shops = ref.watch(chemistShopNotifierProvider).shops;
  try {
    return shops.firstWhere((s) => s.id == id);
  } catch (e) {
    return null;
  }
});
