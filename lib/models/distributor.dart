class Distributor {
  final String id;
  final String name;
  final String location;
  final String phoneNo;
  final String? email;
  final String? address;
  final String? photoUrl;
  final double minimumOrderValue;
  final String deliveryTime;
  final String description;

  Distributor({
    required this.id,
    required this.name,
    required this.location,
    required this.phoneNo,
    this.email,
    this.address,
    this.photoUrl,
    required this.minimumOrderValue,
    required this.deliveryTime,
    required this.description,
  });

  Distributor copyWith({
    String? id,
    String? name,
    String? location,
    String? phoneNo,
    String? email,
    String? address,
    String? photoUrl,
    double? minimumOrderValue,
    String? deliveryTime,
    String? description,
  }) {
    return Distributor(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      minimumOrderValue: minimumOrderValue ?? this.minimumOrderValue,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Distributor &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
