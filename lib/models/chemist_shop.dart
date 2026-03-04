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
  final String id;
  final String name;
  final String location;
  final String? photoUrl;
  final String mrName;
  final String? email;
  final String? address;
  final String phoneNo;
  final String description;
  final List<Doctor> doctors;

  ChemistShop({
    required this.id,
    required this.name,
    required this.location,
    this.photoUrl,
    required this.mrName,
    this.email,
    this.address,
    required this.phoneNo,
    required this.description,
    required this.doctors,
  });

  ChemistShop copyWith({
    String? id,
    String? name,
    String? location,
    String? photoUrl,
    String? mrName,
    String? email,
    String? address,
    String? phoneNo,
    String? description,
    List<Doctor>? doctors,
  }) {
    return ChemistShop(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      photoUrl: photoUrl ?? this.photoUrl,
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
