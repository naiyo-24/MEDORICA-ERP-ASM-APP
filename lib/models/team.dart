import '../services/api_url.dart';

class TeamLeader {
  final String asmId;
  final String fullName;
  final String phoneNo;

  const TeamLeader({
    required this.asmId,
    required this.fullName,
    required this.phoneNo,
  });

  factory TeamLeader.fromJson(Map<String, dynamic> json) {
    return TeamLeader(
      asmId: (json['asm_id'] ?? '').toString(),
      fullName: (json['full_name'] ?? '').toString(),
      phoneNo: (json['phone_no'] ?? '').toString(),
    );
  }
}

class TeamMemberProfile {
  final String mrId;
  final String fullName;
  final String phoneNo;
  final String? altPhoneNo;
  final String? email;
  final String? address;
  final String? headquarterAssigned;
  final List<String> territoriesOfWork;
  final String? profilePhoto;

  const TeamMemberProfile({
    required this.mrId,
    required this.fullName,
    required this.phoneNo,
    this.altPhoneNo,
    this.email,
    this.address,
    this.headquarterAssigned,
    this.territoriesOfWork = const [],
    this.profilePhoto,
  });

  factory TeamMemberProfile.fromJson(Map<String, dynamic> json) {
    final profilePhoto = _normalizeUrl(json['profile_photo']);
    return TeamMemberProfile(
      mrId: (json['mr_id'] ?? '').toString(),
      fullName: (json['full_name'] ?? '').toString(),
      phoneNo: (json['phone_no'] ?? '').toString(),
      altPhoneNo: _stringOrNull(json['alt_phone_no']),
      email: _stringOrNull(json['email']),
      address: _stringOrNull(json['address']),
      headquarterAssigned: _stringOrNull(json['headquarter_assigned']),
      territoriesOfWork: _parseStringList(json['territories_of_work']),
      profilePhoto: profilePhoto,
    );
  }

  static String? _normalizeUrl(dynamic value) {
    final raw = _stringOrNull(value);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    return raw.startsWith('/')
        ? ApiUrl.getFullUrl(raw)
        : ApiUrl.getFullUrl('/$raw');
  }
}

class Team {
  final String id;
  final int? dbId;
  final int? numericTeamId;
  final String name;
  final String headquarter;
  final String territory;
  final String description;
  final String? groupLink;
  final List<String> members;
  final String teamLeaderAsmId;
  final List<String> teamMemberMrIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final TeamLeader? leader;
  final List<TeamMemberProfile> teamMembers;

  Team({
    required this.id,
    this.dbId,
    this.numericTeamId,
    required this.name,
    required this.headquarter,
    required this.territory,
    required this.description,
    this.groupLink,
    this.members = const [],
    this.teamLeaderAsmId = '',
    this.teamMemberMrIds = const [],
    this.createdAt,
    this.updatedAt,
    this.leader,
    this.teamMembers = const [],
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    final parsedMembers = _parseTeamMembers(json['team_members']);
    final memberNames = parsedMembers.map((member) => member.fullName).toList();
    final territories = <String>{};
    for (final member in parsedMembers) {
      territories.addAll(member.territoriesOfWork.where((e) => e.isNotEmpty));
    }

    return Team(
      id: (json['team_id'] ?? json['id'] ?? '').toString(),
      dbId: _toIntOrNull(json['id']),
      numericTeamId: _toIntOrNull(json['team_id']),
      name: (json['team_name'] ?? '').toString(),
      headquarter: _deriveHeadquarter(parsedMembers),
      territory: territories.join(', '),
      description: _stringOrNull(json['team_description']) ?? '',
      groupLink: _stringOrNull(json['whatsapp_group_link']),
      members: memberNames,
      teamLeaderAsmId: (json['team_leader_asm_id'] ?? '').toString(),
      teamMemberMrIds: _parseStringList(json['team_members_mr_ids']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      leader: json['team_leader'] is Map<String, dynamic>
          ? TeamLeader.fromJson(json['team_leader'] as Map<String, dynamic>)
          : null,
      teamMembers: parsedMembers,
    );
  }

  Team copyWith({
    String? id,
    int? dbId,
    int? numericTeamId,
    String? name,
    String? headquarter,
    String? territory,
    String? description,
    String? groupLink,
    List<String>? members,
    String? teamLeaderAsmId,
    List<String>? teamMemberMrIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    TeamLeader? leader,
    List<TeamMemberProfile>? teamMembers,
  }) {
    return Team(
      id: id ?? this.id,
      dbId: dbId ?? this.dbId,
      numericTeamId: numericTeamId ?? this.numericTeamId,
      name: name ?? this.name,
      headquarter: headquarter ?? this.headquarter,
      territory: territory ?? this.territory,
      description: description ?? this.description,
      groupLink: groupLink ?? this.groupLink,
      members: members ?? this.members,
      teamLeaderAsmId: teamLeaderAsmId ?? this.teamLeaderAsmId,
      teamMemberMrIds: teamMemberMrIds ?? this.teamMemberMrIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      leader: leader ?? this.leader,
      teamMembers: teamMembers ?? this.teamMembers,
    );
  }

  static List<TeamMemberProfile> _parseTeamMembers(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(TeamMemberProfile.fromJson)
        .toList();
  }

  static String _deriveHeadquarter(List<TeamMemberProfile> members) {
    for (final member in members) {
      final hq = member.headquarterAssigned;
      if (hq != null && hq.trim().isNotEmpty) {
        return hq.trim();
      }
    }
    return '-';
  }
}

String? _stringOrNull(dynamic value) {
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

DateTime? _parseDateTime(dynamic value) {
  final raw = _stringOrNull(value);
  if (raw == null) {
    return null;
  }
  return DateTime.tryParse(raw)?.toLocal();
}

List<String> _parseStringList(dynamic value) {
  if (value == null) {
    return const [];
  }

  if (value is List) {
    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  final text = value.toString().trim();
  if (text.isEmpty) {
    return const [];
  }

  final normalized = text.replaceAll('[', '').replaceAll(']', '');
  return normalized
      .split(',')
      .map((item) => item.trim().replaceAll('"', '').replaceAll("'", ''))
      .where((item) => item.isNotEmpty)
      .toList();
}
