import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../cards/chemist_shop/chemist_shop_card.dart';
import '../../cards/chemist_shop/chemist_shop_search_filter_card.dart';
import '../../models/chemist_shop.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chemist_shop_provider.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

class ChemistShopScreen extends ConsumerStatefulWidget {
  const ChemistShopScreen({super.key});

  @override
  ConsumerState<ChemistShopScreen> createState() => _ChemistShopScreenState();
}

class _ChemistShopScreenState extends ConsumerState<ChemistShopScreen> {
  String _searchQuery = '';

  List<ChemistShop> _filterShops(List<ChemistShop> all) {
    if (_searchQuery.isEmpty) return all;
    final q = _searchQuery.toLowerCase();
    return all
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              (s.location?.toLowerCase().contains(q) ?? false) ||
              (s.address?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(chemistShopNotifierProvider);
    final filteredShops = _filterShops(shopState.shops);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(AppRouter.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: const MRAppBar(
          showBack: false,
          showActions: false,
          titleText: 'Chemist Shops',
          subtitleText: 'Manage your retail partners',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingHorizontal,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.lg),
              // Search and Filter
              ChemistShopSearchFilterCard(
                onSearch: (query) => setState(() => _searchQuery = query),
              ),
              // Body
              Expanded(
                child: shopState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : shopState.error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.warning_2,
                                size: 64,
                                color: AppColors.quaternary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                shopState.error!,
                                style: AppTypography.body.copyWith(
                                  color: AppColors.quaternary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  final asmId = ref
                                      .read(authNotifierProvider)
                                      .asmId;
                                  if (asmId != null) {
                                    ref
                                        .read(
                                          chemistShopNotifierProvider.notifier,
                                        )
                                        .loadShopsByAsmId(asmId);
                                  }
                                },
                                icon: const Icon(Iconsax.refresh),
                                label: const Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : filteredShops.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.shop,
                              size: 80,
                              color: AppColors.primaryLight,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No Chemist Shops Found',
                              style: AppTypography.h3.copyWith(
                                color: AppColors.quaternary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add your first chemist shop to get started',
                              style: AppTypography.body.copyWith(
                                color: AppColors.quaternary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: filteredShops.length,
                        itemBuilder: (context, index) {
                          final shop = filteredShops[index];
                          return ChemistShopCard(
                            shop: shop,
                            onTap: () {
                              context.push(
                                '/chemist-shop-detail/${shop.id}',
                                extra: shop,
                              );
                            },
                            onEdit: () {
                              context.push(
                                '/add-edit-chemist-shop/${shop.id}',
                                extra: shop,
                              );
                            },
                            onDelete: () => _showDeleteConfirmation(shop),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () => context.push(AppRouter.addEditChemistShop),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(180),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Iconsax.add_square,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Add a new Chemist Shop',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const MRBottomNavBar(currentIndex: 3),
      ),
    );
  }

  void _showDeleteConfirmation(ChemistShop shop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chemist Shop'),
        content: Text('Are you sure you want to delete ${shop.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final asmId = ref.read(authNotifierProvider).asmId;
              if (asmId == null) return;
              try {
                await ref
                    .read(chemistShopNotifierProvider.notifier)
                    .deleteShop(asmId: asmId, shopId: shop.id);
              } catch (_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete ${shop.name}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
