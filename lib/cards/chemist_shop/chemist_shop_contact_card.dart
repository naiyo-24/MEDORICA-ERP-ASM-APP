import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/chemist_shop.dart';
import '../../theme/app_theme.dart';

class ChemistShopContactCard extends StatelessWidget {
  final ChemistShop shop;

  const ChemistShopContactCard({super.key, required this.shop});

  Future<void> _launchDialer(String phoneNo) async {
    final phoneUrl = 'tel:${phoneNo.replaceAll(RegExp(r'[^\d+]'), '')}';
    if (await canLaunchUrl(Uri.parse(phoneUrl))) {
      await launchUrl(Uri.parse(phoneUrl), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail(String email) async {
    final emailUrl = 'mailto:$email';
    if (await canLaunchUrl(Uri.parse(emailUrl))) {
      await launchUrl(Uri.parse(emailUrl), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchMaps(String address) async {
    final mapsUrl =
        'https://www.google.com/maps/search/${Uri.encodeComponent(address)}';
    if (await canLaunchUrl(Uri.parse(mapsUrl))) {
      await launchUrl(Uri.parse(mapsUrl), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: AppTypography.h3.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 16),
            // Phone
            GestureDetector(
              onTap: () => _launchDialer(shop.phoneNo),
              child: _ContactItem(
                icon: Iconsax.call,
                label: 'Phone',
                value: shop.phoneNo,
              ),
            ),
            const SizedBox(height: 10),
            // Email
            if (shop.email != null && shop.email!.isNotEmpty)
              GestureDetector(
                onTap: () => _launchEmail(shop.email!),
                child: _ContactItem(
                  icon: Iconsax.sms,
                  label: 'Email',
                  value: shop.email!,
                ),
              ),
            if (shop.email != null && shop.email!.isNotEmpty)
              const SizedBox(height: 10),
            // Address
            if (shop.address != null && shop.address!.isNotEmpty)
              GestureDetector(
                onTap: () => _launchMaps(shop.address!),
                child: _ContactItem(
                  icon: Iconsax.location,
                  label: 'Address',
                  value: shop.address!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withAlpha(100),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryLight.withAlpha(150),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.quaternary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: AppTypography.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Iconsax.arrow_right,
            color: AppColors.quaternary,
            size: 18,
          ),
        ],
      ),
    );
  }
}
