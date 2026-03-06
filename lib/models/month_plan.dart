class PlanStep {
  final String time; // e.g. "10:00 AM"
  final String title;
  final String description;

  PlanStep({required this.time, required this.title, required this.description});
}

class MonthPlanEntry {
  final String id;
  final String memberId; // TeamMember id
  final DateTime date; // exact date for the plan
  final List<PlanStep> steps;

  MonthPlanEntry({required this.id, required this.memberId, required this.date, this.steps = const []});

  MonthPlanEntry copyWith({String? id, String? memberId, DateTime? date, List<PlanStep>? steps}) {
    return MonthPlanEntry(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      date: date ?? this.date,
      steps: steps ?? this.steps,
    );
  }
}
