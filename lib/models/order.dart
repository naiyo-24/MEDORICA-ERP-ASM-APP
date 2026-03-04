class Medicine {
  final String id;
  final String name;
  final int quantity;
  final String pack;
  final double totalAmount;

  Medicine({
    required this.id,
    required this.name,
    required this.quantity,
    required this.pack,
    required this.totalAmount,
  });
}

enum OrderStatus { approved, rejected, pending, cancelled, delivered, received }

class Order {
  final String id;
  final String chemistShopName;
  final String chemistShopPhoneNo;
  final String chemistShopAddress;
  final String chemistShopId;
  final String doctorName;
  final String distributorName;
  final String distributorPhoneNo;
  final String distributorAddress;
  final String distributorDeliveryTime;
  final String distributorId;
  final List<Medicine> medicines;
  final OrderStatus status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.chemistShopName,
    required this.chemistShopPhoneNo,
    required this.chemistShopAddress,
    required this.chemistShopId,
    required this.doctorName,
    required this.distributorName,
    required this.distributorPhoneNo,
    required this.distributorAddress,
    required this.distributorDeliveryTime,
    required this.distributorId,
    required this.medicines,
    required this.status,
    required this.createdAt,
  });

  Order copyWith({
    String? id,
    String? chemistShopName,
    String? chemistShopPhoneNo,
    String? chemistShopAddress,
    String? chemistShopId,
    String? doctorName,
    String? distributorName,
    String? distributorPhoneNo,
    String? distributorAddress,
    String? distributorDeliveryTime,
    String? distributorId,
    List<Medicine>? medicines,
    OrderStatus? status,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      chemistShopName: chemistShopName ?? this.chemistShopName,
      chemistShopPhoneNo: chemistShopPhoneNo ?? this.chemistShopPhoneNo,
      chemistShopAddress: chemistShopAddress ?? this.chemistShopAddress,
      chemistShopId: chemistShopId ?? this.chemistShopId,
      doctorName: doctorName ?? this.doctorName,
      distributorName: distributorName ?? this.distributorName,
      distributorPhoneNo: distributorPhoneNo ?? this.distributorPhoneNo,
      distributorAddress: distributorAddress ?? this.distributorAddress,
      distributorDeliveryTime:
          distributorDeliveryTime ?? this.distributorDeliveryTime,
      distributorId: distributorId ?? this.distributorId,
      medicines: medicines ?? this.medicines,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
