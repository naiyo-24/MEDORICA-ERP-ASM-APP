import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io';
import '../../models/chemist_shop.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';

class ChemistShopHeaderCard extends StatelessWidget {
  final ChemistShop shop;

  const ChemistShopHeaderCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final resolvedPhotoUrl = _resolvePhotoUrl(shop.photoUrl);
    final shouldUseNetworkImage =
        resolvedPhotoUrl != null && resolvedPhotoUrl.startsWith('http');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(120),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primary.withAlpha(180)],
              ),
            ),
            child: resolvedPhotoUrl != null && resolvedPhotoUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: shouldUseNetworkImage
                        ? Image.network(
                            resolvedPhotoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const SizedBox(),
                          )
                        : Image.file(File(resolvedPhotoUrl), fit: BoxFit.cover),
                  )
                : null,
          ),
          // Dark Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(80),
                  Colors.black.withAlpha(220),
                ],
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Shop ID Badge at top
                if (shop.asmId != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(220),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.shop, color: AppColors.primary, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          shop.id,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (shop.asmId == null) const SizedBox(),
                // Name and Location at bottom
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: AppTypography.h2.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (shop.location != null && shop.location!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Iconsax.location,
                            color: AppColors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              shop.location!,
                              style: AppTypography.body.copyWith(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _resolvePhotoUrl(String? rawPath) {
    if (rawPath == null || rawPath.isEmpty) return null;
    if (rawPath.startsWith('http://') || rawPath.startsWith('https://')) {
      return ApiUrl.getFullUrl(rawPath);
    }
    if (rawPath.startsWith('uploads/') || rawPath.startsWith('/uploads/')) {
      return ApiUrl.getFullUrl(rawPath);
    }
    return rawPath;
  }
}
