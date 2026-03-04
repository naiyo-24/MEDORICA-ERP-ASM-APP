class MonthlyTarget {
  final String month; // Format: "YYYY-MM" (e.g., "2026-03" for March 2026)
  final double targetAmount;
  final DateTime createdAt;

  MonthlyTarget({
    required this.month,
    required this.targetAmount,
    required this.createdAt,
  });

  MonthlyTarget copyWith({
    String? month,
    double? targetAmount,
    DateTime? createdAt,
  }) {
    return MonthlyTarget(
      month: month ?? this.month,
      targetAmount: targetAmount ?? this.targetAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TeamMember {
  final String id;
  final String name;
  final String phone;
  final String? altPhone;
  final String? email;
  final String? photoUrl;
  final String headquarter;
  final List<String> territories;
  final String teamId;
  final Map<String, MonthlyTarget>? monthlyTargets; // Key: "YYYY-MM"

  TeamMember({
    required this.id,
    required this.name,
    required this.phone,
    this.altPhone,
    this.email,
    this.photoUrl,
    required this.headquarter,
    this.territories = const [],
    required this.teamId,
    this.monthlyTargets,
  });

  TeamMember copyWith({
    String? id,
    String? name,
    String? phone,
    String? altPhone,
    String? email,
    String? photoUrl,
    String? headquarter,
    List<String>? territories,
    String? teamId,
    Map<String, MonthlyTarget>? monthlyTargets,
  }) {
    return TeamMember(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      altPhone: altPhone ?? this.altPhone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      headquarter: headquarter ?? this.headquarter,
      territories: territories ?? this.territories,
      teamId: teamId ?? this.teamId,
      monthlyTargets: monthlyTargets ?? this.monthlyTargets,
    );
  }

  // Get target for specific month
  MonthlyTarget? getTargetForMonth(String month) {
    return monthlyTargets?[month];
  }

  // Get current month's target
  MonthlyTarget? getCurrentMonthTarget() {
    final now = DateTime.now();
    final currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    return monthlyTargets?[currentMonth];
  }
}
