import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../cards/order/order_card.dart';
import '../../cards/order/order_details_bottomsheet.dart';
import '../../cards/order/order_search_filter_card.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  String _searchQuery = '';
  OrderStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderNotifierProvider);
    final allOrders = orderState.orders;
    final filteredOrders = _filterOrders(allOrders);

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
          titleText: 'My Orders',
          subtitleText: 'Track your orders',
          showActions: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingHorizontal,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.md),
              // Search and Filter Section
              OrderSearchFilterCard(
                onSearchChanged: (query) {
                  setState(() => _searchQuery = query);
                },
                onStatusFilterChanged: (status) {
                  setState(() => _selectedStatus = status);
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Orders List
              Expanded(
                child: orderState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredOrders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.note_remove,
                              size: 64,
                              color: AppColors.quaternary.withAlpha(150),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No orders found',
                              style: AppTypography.h3.copyWith(
                                color: AppColors.quaternary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              orderState.error ??
                                  (_searchQuery.isNotEmpty
                                      ? 'Try adjusting your search'
                                      : 'No orders available'),
                              style: AppTypography.body.copyWith(
                                color: AppColors.quaternary.withAlpha(150),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: OrderCard(
                              order: order,
                              onTap: () => _showOrderDetails(order),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () => context.push(AppRouter.createOrder),
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
                  color: AppColors.primary.withOpacity(0.18),
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
                const SizedBox(width: 8),
                Text(
                  'Create a new Order',
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
        bottomNavigationBar: const MRBottomNavBar(currentIndex: 2),
      ),
    );
  }

  List<Order> _filterOrders(List<Order> orders) {
    var filtered = orders;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (order) =>
                order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                order.chemistShopName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                order.distributorName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    // Apply status filter
    if (_selectedStatus != null) {
      filtered = filtered
          .where((order) => order.status == _selectedStatus)
          .toList();
    }

    return filtered;
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDetailsBottomSheet(order: order),
    );
  }
}
