import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/month_plan.dart';

class PlanCard extends StatelessWidget {
  final MonthPlanEntry entry;
  const PlanCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppCardStyles.styleCard(backgroundColor: AppColors.white, borderRadius: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${entry.date.day}-${entry.date.month}-${entry.date.year}', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.sm),
          ...entry.steps.map((s) => _stepTile(s)).toList(),
        ],
      ),
    );
  }

  Widget _stepTile(PlanStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppBorderRadius.md)),
      child: Row(
        children: [
          SizedBox(width: 72, child: Text(step.time, style: AppTypography.bodySmall.copyWith(color: AppColors.quaternary))),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.xs),
                Text(step.description, style: AppTypography.caption.copyWith(color: AppColors.quaternary)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
