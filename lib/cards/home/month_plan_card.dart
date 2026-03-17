import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';

class MonthPlanCard extends StatelessWidget {
  const MonthPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppCardStyles.styleCard(backgroundColor: AppColors.primary, borderRadius: 18.0),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.calendar_today, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Monthly Planning', style: AppTypography.bodyLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.w800)),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Create and view daily plans for your team — schedule step-by-step activities for each MR and track their monthly plan.', style: AppTypography.description.copyWith(color: AppColors.white, height: 1.3)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.push('/month-plans'),
                  style: AppButtonStyles.secondaryButton(borderRadius: 12.0),
                  child: Text('View Plan', style: AppTypography.buttonMedium.copyWith(color: AppColors.primary)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.push('/month-plans/create'),
                  style: AppButtonStyles.primaryButton(
                    borderRadius: 12.0,
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.secondary,
                  ),
                  child: Text('Create Plan', style: AppTypography.buttonMedium.copyWith(color: AppColors.primary)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
