import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../cards/order/order_card.dart';
import '../../cards/order/order_details_bottomsheet.dart';
import '../../cards/order/order_search_filter_card.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

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
    final allOrders = ref.watch(orderNotifierProvider);
    final filteredOrders = _filterOrders(allOrders);

    return Scaffold(
      appBar: const MRAppBar(
        titleText: 'MR Orders',
        subtitleText: 'Track your orders',
        showActions: false,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: OrderSearchFilterCard(
              onSearchChanged: (query) {
                setState(() => _searchQuery = query);
              },
              onStatusFilterChanged: (status) {
                setState(() => _selectedStatus = status);
              },
            ),
          ),

          // Orders List
          Expanded(
            child: filteredOrders.isEmpty
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
                          _searchQuery.isNotEmpty
                              ? 'Try adjusting your search'
                              : 'No orders available',
                          style: AppTypography.body.copyWith(
                            color: AppColors.quaternary.withAlpha(150),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredOrders.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return OrderCard(
                        order: order,
                        onTap: () => _showOrderDetails(order),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Order> _filterOrders(List<Order> orders) {
    var filtered = orders;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((order) =>
              order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              order.mrName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              order.chemistShopName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              order.distributorName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply status filter
    if (_selectedStatus != null) {
      filtered = filtered.where((order) => order.status == _selectedStatus).toList();
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
