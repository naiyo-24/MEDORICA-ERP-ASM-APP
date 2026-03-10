import 'package:flutter/foundation.dart';

/// Model class for Area Sales Manager
class ASM {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? profileImage;
  final String? altPhone;
  final String? address;
  final DateTime? joiningDate;
  final String? password;
  final String? bankName;
  final String? bankAccountNo;
  final String? ifscCode;
  final String? branchName;
  final String? mrId;
  final String? headquarterAssigned;
  final List<String> territoriesOfWork;
  final double? monthlyTarget;
  final double? basicSalary;
  final double? dailyAllowances;
  final double? hra;
  final double? childrenEducationAllowance;
  final double? specialAllowance;
  final double? phoneAllowance;
  final double? medicalAllowance;
  final double? esic;
  final double? totalMonthlySalary;
  final String? region;
  final String? territory;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  ASM({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.profileImage,
    this.altPhone,
    this.address,
    this.joiningDate,
    this.password,
    this.bankName,
    this.bankAccountNo,
    this.ifscCode,
    this.branchName,
    this.mrId,
    this.headquarterAssigned,
    this.territoriesOfWork = const [],
    this.monthlyTarget,
    this.basicSalary,
    this.dailyAllowances,
    this.hra,
    this.childrenEducationAllowance,
    this.specialAllowance,
    this.phoneAllowance,
    this.medicalAllowance,
    this.esic,
    this.totalMonthlySalary,
    this.region,
    this.territory,
    this.createdAt,
    this.lastLogin,
  });

  static double? _readDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  static List<String> _readTerritories(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    if (value is String) {
      return value
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const [];
  }

  /// Create ASM from JSON
  factory ASM.fromJson(Map<String, dynamic> json) {
    final dailyAllowances = _readDouble(json['dailyAllowances']);
    final basicSalary = _readDouble(json['basicSalary']);
    final hra = _readDouble(json['hra']);
    final childrenEducationAllowance = _readDouble(
      json['childrenEducationAllowance'],
    );
    final specialAllowance = _readDouble(json['specialAllowance']);
    final phoneAllowance = _readDouble(json['phoneAllowance']);
    final medicalAllowance = _readDouble(json['medicalAllowance']);
    final esic = _readDouble(json['esic']);

    return ASM(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String?,
      altPhone: json['altPhone'] as String?,
      address: json['address'] as String?,
      joiningDate: json['joiningDate'] != null
          ? DateTime.parse(json['joiningDate'] as String)
          : null,
      password: json['password'] as String?,
      bankName: json['bankName'] as String?,
      bankAccountNo: json['bankAccountNo'] as String?,
      ifscCode: json['ifscCode'] as String?,
      branchName: json['branchName'] as String?,
      mrId: json['mrId'] as String?,
      headquarterAssigned: json['headquarterAssigned'] as String?,
      territoriesOfWork: _readTerritories(json['territoriesOfWork']),
      monthlyTarget: _readDouble(json['monthlyTarget']),
      basicSalary: basicSalary,
      dailyAllowances: dailyAllowances,
      hra: hra,
      childrenEducationAllowance: childrenEducationAllowance,
      specialAllowance: _readDouble(json['specialAllowance']),
      phoneAllowance: phoneAllowance,
      medicalAllowance: medicalAllowance,
      esic: esic,
      totalMonthlySalary:
          _readDouble(json['totalMonthlySalary']) ??
          (basicSalary ?? 0) +
              (dailyAllowances ?? 0) +
              (hra ?? 0) +
              (childrenEducationAllowance ?? 0) +
              (specialAllowance ?? 0) +
              (phoneAllowance ?? 0) +
              (medicalAllowance ?? 0) -
              (esic ?? 0),
      region: json['region'] as String?,
      territory: json['territory'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
    );
  }

  /// Convert ASM to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'profileImage': profileImage,
      'altPhone': altPhone,
      'address': address,
      'joiningDate': joiningDate?.toIso8601String(),
      'password': password,
      'bankName': bankName,
      'bankAccountNo': bankAccountNo,
      'ifscCode': ifscCode,
      'branchName': branchName,
      'mrId': mrId,
      'headquarterAssigned': headquarterAssigned,
      'territoriesOfWork': territoriesOfWork,
      'monthlyTarget': monthlyTarget,
      'basicSalary': basicSalary,
      'dailyAllowances': dailyAllowances,
      'hra': hra,
      'childrenEducationAllowance': childrenEducationAllowance,
      'specialAllowance': specialAllowance,
      'phoneAllowance': phoneAllowance,
      'medicalAllowance': medicalAllowance,
      'esic': esic,
      'totalMonthlySalary': totalMonthlySalary,
      'region': region,
      'territory': territory,
      'createdAt': createdAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  /// Create a copy of ASM with updated fields
  ASM copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? profileImage,
    String? altPhone,
    String? address,
    DateTime? joiningDate,
    String? password,
    String? bankName,
    String? bankAccountNo,
    String? ifscCode,
    String? branchName,
    String? mrId,
    String? headquarterAssigned,
    List<String>? territoriesOfWork,
    double? monthlyTarget,
    double? basicSalary,
    double? dailyAllowances,
    double? hra,
    double? childrenEducationAllowance,
    double? specialAllowance,
    double? phoneAllowance,
    double? medicalAllowance,
    double? esic,
    double? totalMonthlySalary,
    String? region,
    String? territory,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return ASM(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      altPhone: altPhone ?? this.altPhone,
      address: address ?? this.address,
      joiningDate: joiningDate ?? this.joiningDate,
      password: password ?? this.password,
      bankName: bankName ?? this.bankName,
      bankAccountNo: bankAccountNo ?? this.bankAccountNo,
      ifscCode: ifscCode ?? this.ifscCode,
      branchName: branchName ?? this.branchName,
      mrId: mrId ?? this.mrId,
      headquarterAssigned: headquarterAssigned ?? this.headquarterAssigned,
      territoriesOfWork: territoriesOfWork ?? this.territoriesOfWork,
      monthlyTarget: monthlyTarget ?? this.monthlyTarget,
      basicSalary: basicSalary ?? this.basicSalary,
      dailyAllowances: dailyAllowances ?? this.dailyAllowances,
      hra: hra ?? this.hra,
      childrenEducationAllowance:
          childrenEducationAllowance ?? this.childrenEducationAllowance,
      specialAllowance: specialAllowance ?? this.specialAllowance,
      phoneAllowance: phoneAllowance ?? this.phoneAllowance,
      medicalAllowance: medicalAllowance ?? this.medicalAllowance,
      esic: esic ?? this.esic,
      totalMonthlySalary: totalMonthlySalary ?? this.totalMonthlySalary,
      region: region ?? this.region,
      territory: territory ?? this.territory,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  @override
  String toString() {
    return 'ASM(id: $id, name: $name, phone: $phone, email: $email, mrId: $mrId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ASM &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.profileImage == profileImage &&
        other.altPhone == altPhone &&
        other.address == address &&
        other.joiningDate == joiningDate &&
        other.password == password &&
        other.bankName == bankName &&
        other.bankAccountNo == bankAccountNo &&
        other.ifscCode == ifscCode &&
        other.branchName == branchName &&
        other.mrId == mrId &&
        other.headquarterAssigned == headquarterAssigned &&
        listEquals(other.territoriesOfWork, territoriesOfWork) &&
        other.monthlyTarget == monthlyTarget &&
        other.basicSalary == basicSalary &&
        other.dailyAllowances == dailyAllowances &&
        other.hra == hra &&
        other.childrenEducationAllowance == childrenEducationAllowance &&
        other.specialAllowance == specialAllowance &&
        other.phoneAllowance == phoneAllowance &&
        other.medicalAllowance == medicalAllowance &&
        other.esic == esic &&
        other.totalMonthlySalary == totalMonthlySalary &&
        other.region == region &&
        other.territory == territory &&
        other.createdAt == createdAt &&
        other.lastLogin == lastLogin;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      name,
      phone,
      email,
      profileImage,
      altPhone,
      address,
      joiningDate,
      password,
      bankName,
      bankAccountNo,
      ifscCode,
      branchName,
      mrId,
      headquarterAssigned,
      Object.hashAll(territoriesOfWork),
      monthlyTarget,
      basicSalary,
      dailyAllowances,
      hra,
      childrenEducationAllowance,
      specialAllowance,
      phoneAllowance,
      medicalAllowance,
      esic,
      totalMonthlySalary,
      region,
      territory,
      createdAt,
      lastLogin,
    ]);
  }
}
