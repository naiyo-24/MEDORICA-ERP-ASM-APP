import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/month_plan_provider.dart';

class CalendarCard extends ConsumerStatefulWidget {
  final String memberId;
  final ValueChanged<DateTime>? onDateSelected;
  const CalendarCard({super.key, required this.memberId, this.onDateSelected});

  @override
  ConsumerState<CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends ConsumerState<CalendarCard> {
  DateTime _focused = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final year = _focused.year;
    final month = _focused.month;
    final entries = ref.watch(monthPlanForMemberProvider(widget.memberId));
    final daysWithPlans = entries.where((e) => e.date.year == year && e.date.month == month).map((e) => e.date.day).toSet();

    final first = DateTime(year, month, 1);
    final last = DateTime(year, month + 1, 0);

    final leadingEmpty = first.weekday % 7; // 0..6
    final totalCells = leadingEmpty + last.day;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppCardStyles.styleCard(backgroundColor: AppColors.white, borderRadius: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() => _focused = DateTime(_focused.year, _focused.month - 1, 1)),
              ),
              Text('${_monthName(_focused.month)} ${_focused.year}', style: AppTypography.h3.copyWith(fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() => _focused = DateTime(_focused.year, _focused.month + 1, 1)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1.2),
            itemCount: totalCells + (7 - (totalCells % 7)) % 7,
            itemBuilder: (context, index) {
              final dayIndex = index - leadingEmpty + 1;
              if (index < leadingEmpty || dayIndex > last.day) {
                return const SizedBox();
              }
              final hasDot = daysWithPlans.contains(dayIndex);
              final date = DateTime(year, month, dayIndex);
              return GestureDetector(
                onTap: () => widget.onDateSelected?.call(date),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(dayIndex.toString(), style: AppTypography.body),
                    const SizedBox(height: 6),
                    if (hasDot)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      )
                    else
                      const SizedBox(height: 6),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _monthName(int m) {
    const names = [
      'January','February','March','April','May','June','July','August','September','October','November','December'
    ];
    return names[m - 1];
  }
}
