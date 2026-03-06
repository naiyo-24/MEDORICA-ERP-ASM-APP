import 'package:flutter_riverpod/legacy.dart';
import '../models/month_plan.dart';
import 'dart:math';

class MonthPlanState {
  final bool isLoading;
  final List<MonthPlanEntry> entries;
  final String? selectedMemberId;
  final DateTime? selectedDate;

  MonthPlanState({this.isLoading = false, this.entries = const [], this.selectedMemberId, this.selectedDate});

  MonthPlanState copyWith({bool? isLoading, List<MonthPlanEntry>? entries, String? selectedMemberId, DateTime? selectedDate}) {
    return MonthPlanState(
      isLoading: isLoading ?? this.isLoading,
      entries: entries ?? this.entries,
      selectedMemberId: selectedMemberId ?? this.selectedMemberId,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class MonthPlanNotifier extends StateNotifier<MonthPlanState> {
  MonthPlanNotifier() : super(MonthPlanState());

  void setLoading(bool loading) => state = state.copyWith(isLoading: loading);

  void setSelectedMember(String? memberId) => state = state.copyWith(selectedMemberId: memberId);

  void setSelectedDate(DateTime date) => state = state.copyWith(selectedDate: date);

  void addEntry(MonthPlanEntry entry) {
    final updated = [...state.entries, entry];
    state = state.copyWith(entries: updated);
  }

  void updateEntry(MonthPlanEntry entry) {
    final updated = state.entries.map((e) => e.id == entry.id ? entry : e).toList();
    state = state.copyWith(entries: updated);
  }

  void removeEntry(String id) {
    final updated = state.entries.where((e) => e.id != id).toList();
    state = state.copyWith(entries: updated);
  }

  List<MonthPlanEntry> entriesForMember(String memberId) {
    return state.entries.where((e) => e.memberId == memberId).toList();
  }

  List<MonthPlanEntry> entriesForMemberAndMonth(String memberId, int year, int month) {
    return state.entries.where((e) => e.memberId == memberId && e.date.year == year && e.date.month == month).toList();
  }

  List<MonthPlanEntry> entriesForMemberAndDate(String memberId, DateTime date) {
    return state.entries.where((e) => e.memberId == memberId && e.date.year == date.year && e.date.month == date.month && e.date.day == date.day).toList();
  }

  String _randomId() => DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(9999).toString();

  // convenience to create and add
  void createPlanForMember(String memberId, DateTime date, List<PlanStep> steps) {
    final entry = MonthPlanEntry(id: _randomId(), memberId: memberId, date: date, steps: steps);
    addEntry(entry);
  }
}
