import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/month_plan_notifier.dart';

final monthPlanNotifierProvider = StateNotifierProvider<MonthPlanNotifier, MonthPlanState>((ref) => MonthPlanNotifier());

final allMonthPlansProvider = Provider<List>((ref) {
  return ref.watch(monthPlanNotifierProvider).entries;
});

final monthPlanForMemberProvider = Provider.family<List, String>((ref, memberId) {
  final state = ref.watch(monthPlanNotifierProvider);
  return state.entries.where((e) => e.memberId == memberId).toList();
});

final monthPlanForMemberAndDateProvider = Provider.family<List, Map<String, dynamic>>((ref, params) {
  final memberId = params['memberId'] as String;
  final date = params['date'] as DateTime;
  final state = ref.watch(monthPlanNotifierProvider);
  return state.entries.where((e) => e.memberId == memberId && e.date.year == date.year && e.date.month == date.month && e.date.day == date.day).toList();
});
