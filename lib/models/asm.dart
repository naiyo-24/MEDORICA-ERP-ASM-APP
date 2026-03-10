import 'package:flutter/foundation.dart';

/// Model class for Area Sales Manager
class ASM {
  static const Object _unset = Object();

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
  final String? asmId;
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
    this.asmId,
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

  static String? _readString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static double? _readDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  static DateTime? _readDateTime(dynamic value) {
    final text = _readString(value);
    if (text == null) {
      return null;
    }

    return DateTime.tryParse(text);
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

  factory ASM.fromLoginJson(Map<String, dynamic> json) {
    final asmId = _readString(json['asm_id']) ?? '';

    return ASM(
      id: asmId,
      name: _readString(json['full_name']) ?? '',
      phone: _readString(json['phone_no']) ?? '',
      email: _readString(json['email']) ?? '',
      asmId: asmId,
    );
  }

  /// Create ASM from JSON
  factory ASM.fromJson(Map<String, dynamic> json) {
    final dailyAllowances = _readDouble(
      json['daily_allowances_rupees'] ?? json['dailyAllowances'],
    );
    final basicSalary = _readDouble(
      json['basic_salary_rupees'] ?? json['basicSalary'],
    );
    final hra = _readDouble(json['hra_rupees'] ?? json['hra']);
    final childrenEducationAllowance = _readDouble(
      json['children_allowances_rupees'] ?? json['childrenEducationAllowance'],
    );
    final specialAllowance = _readDouble(
      json['special_allowances_rupees'] ?? json['specialAllowance'],
    );
    final phoneAllowance = _readDouble(
      json['phone_allowances_rupees'] ?? json['phoneAllowance'],
    );
    final medicalAllowance = _readDouble(
      json['medical_allowances_rupees'] ?? json['medicalAllowance'],
    );
    final esic = _readDouble(json['esic_rupees'] ?? json['esic']);

    return ASM(
      id: _readString(json['id']) ?? '',
      name: _readString(json['full_name'] ?? json['name']) ?? '',
      phone: _readString(json['phone_no'] ?? json['phone']) ?? '',
      email: _readString(json['email']) ?? '',
      profileImage: _readString(json['profile_photo'] ?? json['profileImage']),
      altPhone: _readString(json['alt_phone_no'] ?? json['altPhone']),
      address: _readString(json['address']),
      joiningDate: _readDateTime(json['joining_date'] ?? json['joiningDate']),
      password: _readString(json['password']),
      bankName: _readString(json['bank_name'] ?? json['bankName']),
      bankAccountNo: _readString(
        json['bank_account_no'] ?? json['bankAccountNo'],
      ),
      ifscCode: _readString(json['ifsc_code'] ?? json['ifscCode']),
      branchName: _readString(json['branch_name'] ?? json['branchName']),
      asmId: _readString(json['asm_id'] ?? json['asmId'] ?? json['mr_id']),
      headquarterAssigned: _readString(
        json['headquarter_assigned'] ?? json['headquarterAssigned'],
      ),
      territoriesOfWork: _readTerritories(
        json['territories_of_work'] ?? json['territoriesOfWork'],
      ),
      monthlyTarget: _readDouble(
        json['monthly_target_rupees'] ?? json['monthlyTarget'],
      ),
      basicSalary: basicSalary,
      dailyAllowances: dailyAllowances,
      hra: hra,
      childrenEducationAllowance: childrenEducationAllowance,
      specialAllowance: specialAllowance,
      phoneAllowance: phoneAllowance,
      medicalAllowance: medicalAllowance,
      esic: esic,
      totalMonthlySalary:
          _readDouble(
            json['total_monthly_compensation_rupees'] ??
                json['totalMonthlySalary'],
          ) ??
          (basicSalary ?? 0) +
              (dailyAllowances ?? 0) +
              (hra ?? 0) +
              (childrenEducationAllowance ?? 0) +
              (specialAllowance ?? 0) +
              (phoneAllowance ?? 0) +
              (medicalAllowance ?? 0) -
              (esic ?? 0),
      region: _readString(json['region']),
      territory: _readString(json['territory']),
      createdAt: _readDateTime(json['created_at'] ?? json['createdAt']),
      lastLogin: _readDateTime(
        json['last_login'] ?? json['lastLogin'] ?? json['updated_at'],
      ),
    );
  }

  /// Convert ASM to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'asm_id': asmId,
      'full_name': name,
      'phone_no': phone,
      'email': email,
      'profile_photo': profileImage,
      'alt_phone_no': altPhone,
      'address': address,
      'joining_date': joiningDate?.toIso8601String(),
      'password': password,
      'bank_name': bankName,
      'bank_account_no': bankAccountNo,
      'ifsc_code': ifscCode,
      'branch_name': branchName,
      'headquarter_assigned': headquarterAssigned,
      'territories_of_work': territoriesOfWork,
      'monthly_target_rupees': monthlyTarget,
      'basic_salary_rupees': basicSalary,
      'daily_allowances_rupees': dailyAllowances,
      'hra_rupees': hra,
      'children_allowances_rupees': childrenEducationAllowance,
      'special_allowances_rupees': specialAllowance,
      'phone_allowances_rupees': phoneAllowance,
      'medical_allowances_rupees': medicalAllowance,
      'esic_rupees': esic,
      'total_monthly_compensation_rupees': totalMonthlySalary,
      'region': region,
      'territory': territory,
      'created_at': createdAt?.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  /// Create a copy of ASM with updated fields
  ASM copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    Object? profileImage = _unset,
    Object? altPhone = _unset,
    Object? address = _unset,
    Object? joiningDate = _unset,
    Object? password = _unset,
    Object? bankName = _unset,
    Object? bankAccountNo = _unset,
    Object? ifscCode = _unset,
    Object? branchName = _unset,
    Object? asmId = _unset,
    Object? headquarterAssigned = _unset,
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
    Object? region = _unset,
    Object? territory = _unset,
    Object? createdAt = _unset,
    Object? lastLogin = _unset,
  }) {
    return ASM(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImage: identical(profileImage, _unset)
          ? this.profileImage
          : profileImage as String?,
      altPhone: identical(altPhone, _unset)
          ? this.altPhone
          : altPhone as String?,
      address: identical(address, _unset) ? this.address : address as String?,
      joiningDate: identical(joiningDate, _unset)
          ? this.joiningDate
          : joiningDate as DateTime?,
      password: identical(password, _unset)
          ? this.password
          : password as String?,
      bankName: identical(bankName, _unset)
          ? this.bankName
          : bankName as String?,
      bankAccountNo: identical(bankAccountNo, _unset)
          ? this.bankAccountNo
          : bankAccountNo as String?,
      ifscCode: identical(ifscCode, _unset)
          ? this.ifscCode
          : ifscCode as String?,
      branchName: identical(branchName, _unset)
          ? this.branchName
          : branchName as String?,
      asmId: identical(asmId, _unset) ? this.asmId : asmId as String?,
      headquarterAssigned: identical(headquarterAssigned, _unset)
          ? this.headquarterAssigned
          : headquarterAssigned as String?,
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
      region: identical(region, _unset) ? this.region : region as String?,
      territory: identical(territory, _unset)
          ? this.territory
          : territory as String?,
      createdAt: identical(createdAt, _unset)
          ? this.createdAt
          : createdAt as DateTime?,
      lastLogin: identical(lastLogin, _unset)
          ? this.lastLogin
          : lastLogin as DateTime?,
    );
  }

  @override
  String toString() {
    return 'ASM(id: $id, name: $name, phone: $phone, email: $email, asmId: $asmId)';
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
        other.asmId == asmId &&
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
      asmId,
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
