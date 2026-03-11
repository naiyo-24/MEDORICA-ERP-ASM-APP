import 'package:flutter_riverpod/legacy.dart';

import '../models/chemist_shop.dart';
import '../services/chemist_shop/chemist_shop_services.dart';

class ChemistShopState {
  final List<ChemistShop> shops;
  final bool isLoading;
  final String? error;

  const ChemistShopState({
    this.shops = const [],
    this.isLoading = false,
    this.error,
  });

  ChemistShopState copyWith({
    List<ChemistShop>? shops,
    bool? isLoading,
    String? error,
  }) {
    return ChemistShopState(
      shops: shops ?? this.shops,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChemistShopNotifier extends StateNotifier<ChemistShopState> {
  ChemistShopNotifier(this._services) : super(const ChemistShopState());

  final ChemistShopServices _services;
  String? _activeAsmId;

  Future<void> syncAsm(String? asmId) async {
    final nextAsmId = asmId?.trim();
    if (nextAsmId == null || nextAsmId.isEmpty) {
      _activeAsmId = null;
      state = const ChemistShopState();
      return;
    }

    if (_activeAsmId == nextAsmId &&
        (state.shops.isNotEmpty || state.isLoading)) {
      return;
    }

    _activeAsmId = nextAsmId;
    await loadShopsByAsmId(nextAsmId);
  }

  Future<void> loadShopsByAsmId(String asmId) async {
    final trimmedAsmId = asmId.trim();
    if (trimmedAsmId.isEmpty) {
      state = const ChemistShopState(
        error: 'ASM ID is required to load chemist shops.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final shops = await _services.fetchShopsByAsmId(trimmedAsmId);
      state = state.copyWith(shops: shops, isLoading: false, error: null);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        shops: const [],
        error: _readErrorMessage(error),
      );
    }
  }

  Future<void> addShop({
    required String asmId,
    required ChemistShop shop,
    String? photoPath,
    String? bankPassbookPhotoPath,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final created = await _services.createShop(
        asmId: asmId,
        shop: shop,
        photoPath: photoPath,
        bankPassbookPhotoPath: bankPassbookPhotoPath,
      );
      state = state.copyWith(
        shops: [...state.shops, created],
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
      rethrow;
    }
  }

  Future<void> updateShop({
    required String asmId,
    required String shopId,
    required ChemistShop shop,
    String? photoPath,
    String? bankPassbookPhotoPath,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updated = await _services.updateShop(
        asmId: asmId,
        shopId: shopId,
        shop: shop,
        photoPath: photoPath,
        bankPassbookPhotoPath: bankPassbookPhotoPath,
      );
      state = state.copyWith(
        shops: [
          for (final s in state.shops)
            if (s.id == shopId) updated else s,
        ],
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
      rethrow;
    }
  }

  Future<void> deleteShop({
    required String asmId,
    required String shopId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _services.deleteShop(asmId: asmId, shopId: shopId);
      state = state.copyWith(
        shops: state.shops.where((s) => s.id != shopId).toList(),
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: _readErrorMessage(error));
      rethrow;
    }
  }

  String _readErrorMessage(Object error) {
    final msg = error.toString();
    if (msg.startsWith('Exception: ')) {
      return msg.substring('Exception: '.length);
    }
    return msg;
  }
}
