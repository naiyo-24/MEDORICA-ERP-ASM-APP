import 'dart:io';

import 'package:flutter/material.dart';
import '../../models/asm.dart';
import '../../theme/app_theme.dart';

class ProfileHeaderCard extends StatelessWidget {
  final ASM profile;

  const ProfileHeaderCard({super.key, required this.profile});

  Widget _buildProfileImage() {
    final imagePath = profile.profileImage;

    if (imagePath == null || imagePath.isEmpty) {
      return const Icon(Icons.person, size: 50, color: AppColors.primary);
    }

    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            const Icon(Icons.person, size: 50, color: AppColors.primary),
      );
    }

    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            const Icon(Icons.person, size: 50, color: AppColors.primary),
      );
    }

    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) =>
          const Icon(Icons.person, size: 50, color: AppColors.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Profile Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: ClipOval(child: _buildProfileImage()),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Name
          Text(
            profile.name,
            style: AppTypography.h3.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),

          // Designation
          Text(
            'Area Sales Manager',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.quaternary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Divider
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.lg),

          // Phone and Territory
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Phone
              Column(
                children: [
                  const Icon(Icons.perm_identity, color: AppColors.primary, size: 24),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    profile.asmId ?? profile.id,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.quaternary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              // ASM ID
            ],
          ),
        ],
      ),
    );
  }
}
