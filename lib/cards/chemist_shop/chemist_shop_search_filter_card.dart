import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class ChemistShopSearchFilterCard extends StatefulWidget {
  final Function(String) onSearch;
  final Function(String?) onFilterChange;

  const ChemistShopSearchFilterCard({
    super.key,
    required this.onSearch,
    required this.onFilterChange,
  });

  @override
  State<ChemistShopSearchFilterCard> createState() =>
      _ChemistShopSearchFilterCardState();
}

class _ChemistShopSearchFilterCardState
    extends State<ChemistShopSearchFilterCard> {
  late TextEditingController _searchController;
  String? _selectedFilter;

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
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
              onChanged: widget.onSearch,
              decoration: InputDecoration(
                hintText: 'Search chemist shop...',
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
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _selectedFilter = value);
              widget.onFilterChange(value);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'all', child: Text('All Shops')),
              const PopupMenuItem(
                value: 'popular',
                child: Text('Most Popular'),
              ),
              const PopupMenuItem(value: 'nearest', child: Text('Nearest')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                Iconsax.setting_3,
                color: _selectedFilter != null
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
