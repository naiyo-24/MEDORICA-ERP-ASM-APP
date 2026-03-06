import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../theme/app_theme.dart';
import '../../routes/app_router.dart';

class MRQuickActionsCard extends StatelessWidget {
  const MRQuickActionsCard({super.key});

  Widget _actionTile(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label tapped')));
      },
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: Center(child: Icon(icon, color: AppColors.primary, size: 20)),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      [FontAwesomeIcons.userGroup, 'Team'],
      [Iconsax.shopping_cart, 'Orders'],
      [Iconsax.location, 'Set Targets'],
      [Iconsax.presention_chart, 'Visual Ads'],
      [Iconsax.truck, 'Distributors'],
      [Iconsax.wallet, 'Salary Slip'],
      [Iconsax.shop, 'Chemists'],
      [Iconsax.user, 'Profile'],
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),

        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Quick Actions', style: AppTypography.h3.copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              children: [
                _actionTile(context, items[0][0] as IconData, items[0][1] as String),
                _actionTile(context, items[1][0] as IconData, items[1][1] as String),
                _actionTile(context, items[2][0] as IconData, items[2][1] as String),
                _actionTile(
                  context,
                  items[3][0] as IconData,
                  items[3][1] as String,
                  onTap: () => context.push(AppRouter.visualAds),
                ),
                _actionTile(context, items[4][0] as IconData, items[4][1] as String),
                _actionTile(context, items[5][0] as IconData, items[5][1] as String),
                _actionTile(context, items[6][0] as IconData, items[6][1] as String),
                _actionTile(context, items[7][0] as IconData, items[7][1] as String),
              ],
            ),
          ],
        ),
      ),
    );
  }
}