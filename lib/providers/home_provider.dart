import '../models/attendance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/monthly_target.dart';
import '../notifiers/home_notifier.dart';
import 'auth_provider.dart';

final homeProvider = Provider<HomeMonthlyTarget>((ref) {
  final homeState = ref.watch(homeNotifierProvider);
  return homeState.selectedMonthTarget;
});

final homeSelectedMonthProvider = Provider<DateTime>((ref) {
  final homeState = ref.watch(homeNotifierProvider);
  return homeState.selectedMonth;
});

final homeTodaysAttendanceProvider = FutureProvider<Attendance?>((ref) async {
  final asmId = ref.watch(authNotifierProvider).asmId;
  if (asmId == null || asmId.isEmpty) {
    return null;
  }

  return ref.read(homeNotifierProvider.notifier).fetchTodaysAttendance(asmId);
});
