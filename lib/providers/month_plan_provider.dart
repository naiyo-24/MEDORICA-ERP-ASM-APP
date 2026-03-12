import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/month_plan.dart';
import '../notifiers/auth_notifier.dart';
import '../notifiers/month_plan_notifier.dart';
import '../services/month_plan/month_plan_services.dart';
import 'auth_provider.dart';

final monthPlanServicesProvider = Provider<MonthPlanServices>((ref) {
  return MonthPlanServices();
});

final monthPlanNotifierProvider =
    StateNotifierProvider<MonthPlanNotifier, MonthPlanState>((ref) {
      final notifier = MonthPlanNotifier(ref.read(monthPlanServicesProvider));

      ref.listen<AuthState>(authNotifierProvider, (previous, next) {
        unawaited(notifier.syncAsm(next.asmId));
      });

      unawaited(notifier.syncAsm(ref.read(authNotifierProvider).asmId));
      return notifier;
    });

final allMonthPlansProvider = Provider<List<MonthPlanEntry>>((ref) {
  return ref.watch(monthPlanNotifierProvider).entries;
});

final monthPlanForMemberProvider =
    Provider.family<List<MonthPlanEntry>, String>((ref, memberId) {
      final state = ref.watch(monthPlanNotifierProvider);
      return state.entries.where((e) => e.memberId == memberId).toList();
    });

final monthPlanForMemberAndDateProvider =
    Provider.family<List<MonthPlanEntry>, Map<String, dynamic>>((ref, params) {
      final memberId = params['memberId'] as String;
      final date = params['date'] as DateTime;
      final state = ref.watch(monthPlanNotifierProvider);
      return state.entries
          .where(
            (e) =>
                e.memberId == memberId &&
                e.date.year == date.year &&
                e.date.month == date.month &&
                e.date.day == date.day,
          )
          .toList();
    });

final isMonthPlanLoadingProvider = Provider<bool>((ref) {
  return ref.watch(monthPlanNotifierProvider).isLoading;
});

final isMonthPlanSubmittingProvider = Provider<bool>((ref) {
  return ref.watch(monthPlanNotifierProvider).isSubmitting;
});

final monthPlanErrorProvider = Provider<String?>((ref) {
  return ref.watch(monthPlanNotifierProvider).error;
});
