import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io';
import '../../models/chemist_shop.dart';
import '../../services/api_url.dart';
import '../../theme/app_theme.dart';

class ChemistShopCard extends StatelessWidget {
  final ChemistShop shop;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ChemistShopCard({
    super.key,
    required this.shop,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedPhotoUrl = _resolvePhotoUrl(shop.photoUrl);
    final shouldUseNetworkImage =
        resolvedPhotoUrl != null && resolvedPhotoUrl.startsWith('http');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo Section
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: AppColors.primaryLight,
              ),
              child: resolvedPhotoUrl != null && resolvedPhotoUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: shouldUseNetworkImage
                          ? Image.network(
                              resolvedPhotoUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildDefaultPhotoContainer();
                              },
                            )
                          : Image.file(
                              File(resolvedPhotoUrl),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildDefaultPhotoContainer();
                              },
                            ),
                    )
                  : _buildDefaultPhotoContainer(),
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop Name with Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          style: AppTypography.h3.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: onEdit,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Iconsax.edit,
                                color: AppColors.primary,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: onDelete,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withAlpha(50),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Iconsax.trash,
                                color: Colors.red,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Location / Address
                  if (shop.location != null && shop.location!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Iconsax.location,
                          color: AppColors.quaternary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            shop.location!,
                            style: AppTypography.body.copyWith(
                              color: AppColors.quaternary,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (shop.location != null && shop.location!.isNotEmpty)
                    const SizedBox(height: 10),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultPhotoContainer() {
    return Container(
      color: AppColors.primaryLight.withAlpha(100),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.image, size: 56, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              'No Photo',
              style: AppTypography.body.copyWith(
                color: AppColors.quaternary,
                fontSize: 13,
              ),
            ),
          ],
        ),
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
