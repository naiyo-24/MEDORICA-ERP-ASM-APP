import '../services/api_url.dart';

class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String phoneNo;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.phoneNo,
  });
}

class ChemistShop {
  final String id; // shop_id
  final String? asmId;
  final String name; // shop_name
  final String? location; // derived from address
  final String? photoUrl;
  final String? bankPassbookPhotoUrl;
  final String? mrName;
  final String? email;
  final String? address;
  final String phoneNo;
  final String? description;
  final List<Doctor> doctors;

  ChemistShop({
    required this.id,
    this.asmId,
    required this.name,
    this.location,
    this.photoUrl,
    this.bankPassbookPhotoUrl,
    this.mrName,
    this.email,
    this.address,
    required this.phoneNo,
    this.description,
    this.doctors = const [],
  });

  factory ChemistShop.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as String?;
    final rawPhoto = json['photo'] as String?;
    final rawBankPhoto = json['bank_passbook_photo'] as String?;
    return ChemistShop(
      id: json['shop_id'] as String,
      asmId: json['asm_id'] as String?,
      name: json['shop_name'] as String,
      address: address,
      location: address,
      phoneNo: json['phone_no'] as String,
      email: json['email'] as String?,
      description: json['description'] as String?,
      photoUrl: rawPhoto != null && rawPhoto.isNotEmpty
          ? ApiUrl.getFullUrl(rawPhoto)
          : null,
      bankPassbookPhotoUrl: rawBankPhoto != null && rawBankPhoto.isNotEmpty
          ? ApiUrl.getFullUrl(rawBankPhoto)
          : null,
      doctors: const [],
    );
  }

  ChemistShop copyWith({
    String? id,
    String? asmId,
    String? name,
    String? location,
    String? photoUrl,
    String? bankPassbookPhotoUrl,
    String? mrName,
    String? email,
    String? address,
    String? phoneNo,
    String? description,
    List<Doctor>? doctors,
  }) {
    return ChemistShop(
      id: id ?? this.id,
      asmId: asmId ?? this.asmId,
      name: name ?? this.name,
      location: location ?? this.location,
      photoUrl: photoUrl ?? this.photoUrl,
      bankPassbookPhotoUrl: bankPassbookPhotoUrl ?? this.bankPassbookPhotoUrl,
      mrName: mrName ?? this.mrName,
      email: email ?? this.email,
      address: address ?? this.address,
      phoneNo: phoneNo ?? this.phoneNo,
      description: description ?? this.description,
      doctors: doctors ?? this.doctors,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChemistShop &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
