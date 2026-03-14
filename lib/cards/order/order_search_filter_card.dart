import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/order.dart';
import '../../theme/app_theme.dart';

class OrderSearchFilterCard extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(OrderStatus?) onStatusFilterChanged;

  const OrderSearchFilterCard({
    super.key,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
  });

  @override
  State<OrderSearchFilterCard> createState() => _OrderSearchFilterCardState();
}

class _OrderSearchFilterCardState extends State<OrderSearchFilterCard> {
  late TextEditingController _searchController;
  OrderStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.primaryLight, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search orders...',
                hintStyle: AppTypography.body.copyWith(
                  color: AppColors.quaternary,
                ),
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Iconsax.search_normal,
                  color: AppColors.quaternary,
                  size: 20,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              style: AppTypography.body.copyWith(color: AppColors.primary),
            ),
          ),
          Container(
            width: 1,
            height: 24,
            color: AppColors.primaryLight,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          PopupMenuButton<OrderStatus?>(
            onSelected: (value) {
              setState(() => _selectedStatus = value);
              widget.onStatusFilterChanged(value);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: null, child: Text('All Orders')),
              const PopupMenuItem(
                value: OrderStatus.pending,
                child: Text('Pending'),
              ),
              const PopupMenuItem(
                value: OrderStatus.approved,
                child: Text('Approved'),
              ),
              const PopupMenuItem(
                value: OrderStatus.delivered,
                child: Text('Delivered'),
              ),
              const PopupMenuItem(
                value: OrderStatus.shipped,
                child: Text('Shipped'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Iconsax.setting_3,
                color: _selectedStatus != null
                    ? AppColors.primary
                    : AppColors.quaternary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
