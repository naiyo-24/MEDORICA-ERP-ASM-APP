class PlanStep {
  final String time; // e.g. "09:00-11:00"
  final String title;
  final String description;

  const PlanStep({
    required this.time,
    required this.title,
    required this.description,
  });

  factory PlanStep.fromActivityJson(Map<String, dynamic> json) {
    final location = _readString(json['location']);
    final notes = _readString(json['notes']);
    final description = notes ?? location ?? '';

    return PlanStep(
      time: _readString(json['slot']) ?? '',
      title: _readString(json['type']) ?? 'activity',
      description: description,
    );
  }

  Map<String, dynamic> toActivityJson() {
    return {
      'slot': time,
      'type': title,
      'location': null,
      'notes': description.isEmpty ? null : description,
    };
  }
}

class MemberDayPlan {
  final String mrId;
  final String? mrName;
  final List<PlanStep> activities;

  const MemberDayPlan({
    required this.mrId,
    this.mrName,
    this.activities = const [],
  });

  factory MemberDayPlan.fromJson(Map<String, dynamic> json) {
    final activitiesRaw = json['activities'];
    return MemberDayPlan(
      mrId: (_readString(json['mr_id']) ?? '').trim(),
      mrName: _readString(json['mr_name']),
      activities: activitiesRaw is List
          ? activitiesRaw
                .whereType<Map<String, dynamic>>()
                .map(PlanStep.fromActivityJson)
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mr_id': mrId,
      'mr_name': mrName,
      'activities': activities.map((e) => e.toActivityJson()).toList(),
    };
  }
}

class MonthlyPlanCreatePayload {
  final String asmId;
  final int teamId;
  final DateTime planDate;
  final String status;
  final List<MemberDayPlan> memberDayPlans;

  const MonthlyPlanCreatePayload({
    required this.asmId,
    required this.teamId,
    required this.planDate,
    this.status = 'draft',
    this.memberDayPlans = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'asm_id': asmId,
      'team_id': teamId,
      'plan_date': _dateOnly(planDate),
      'status': status,
      'member_day_plans': memberDayPlans.map((e) => e.toJson()).toList(),
    };
  }
}

class MonthPlanEntry {
  final String id;
  final int? planId;
  final String asmId;
  final int? teamId;
  final String status;
  final String memberId; // MR id
  final String? memberName;
  final DateTime date;
  final List<PlanStep> steps;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MonthPlanEntry({
    required this.id,
    this.planId,
    this.asmId = '',
    this.teamId,
    this.status = 'draft',
    required this.memberId,
    this.memberName,
    required this.date,
    this.steps = const [],
    this.createdAt,
    this.updatedAt,
  });

  static List<MonthPlanEntry> listFromMonthlyPlanJson(
    Map<String, dynamic> json,
  ) {
    final planId = _toIntOrNull(json['id']);
    final asmId = _readString(json['asm_id']) ?? '';
    final teamId = _toIntOrNull(json['team_id']);
    final status = _readString(json['status']) ?? 'draft';
    final date = _parseDate(json['plan_date']) ?? DateTime.now();
    final createdAt = _parseDateTime(json['created_at']);
    final updatedAt = _parseDateTime(json['updated_at']);
    final plans = json['member_day_plans'];

    if (plans is! List) {
      return const [];
    }

    return plans.whereType<Map<String, dynamic>>().map((memberJson) {
      final member = MemberDayPlan.fromJson(memberJson);
      return MonthPlanEntry(
        id: '${planId ?? ''}_${member.mrId}',
        planId: planId,
        asmId: asmId,
        teamId: teamId,
        status: status,
        memberId: member.mrId,
        memberName: member.mrName,
        date: date,
        steps: member.activities,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }).toList();
  }

  factory MonthPlanEntry.fromMrDayPlanJson(Map<String, dynamic> json) {
    final planId = _toIntOrNull(json['id']);
    final mrPlan = json['mr_plan'];
    final member = mrPlan is Map<String, dynamic>
        ? MemberDayPlan.fromJson(mrPlan)
        : const MemberDayPlan(mrId: '');

    return MonthPlanEntry(
      id: '${planId ?? ''}_${member.mrId}',
      planId: planId,
      asmId: _readString(json['asm_id']) ?? '',
      teamId: _toIntOrNull(json['team_id']),
      status: _readString(json['status']) ?? 'draft',
      memberId: member.mrId,
      memberName: member.mrName,
      date: _parseDate(json['plan_date']) ?? DateTime.now(),
      steps: member.activities,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  MonthPlanEntry copyWith({
    String? id,
    int? planId,
    String? asmId,
    int? teamId,
    String? status,
    String? memberId,
    String? memberName,
    DateTime? date,
    List<PlanStep>? steps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MonthPlanEntry(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      asmId: asmId ?? this.asmId,
      teamId: teamId ?? this.teamId,
      status: status ?? this.status,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

String _dateOnly(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String? _readString(dynamic value) {
  if (value == null) {
    return null;
  }
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

int? _toIntOrNull(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  return int.tryParse(value.toString());
}

DateTime? _parseDate(dynamic value) {
  final text = _readString(value);
  if (text == null) {
    return null;
  }
  return DateTime.tryParse(text);
}

DateTime? _parseDateTime(dynamic value) {
  final text = _readString(value);
  if (text == null) {
    return null;
  }
  return DateTime.tryParse(text);
}
