
class Gift {
	final int giftId;
	final String productName;
	final String? description;
	final int quantityInStock;
	final double priceInRupees;
	final DateTime createdAt;
	final DateTime updatedAt;

	Gift({
		required this.giftId,
		required this.productName,
		this.description,
		required this.quantityInStock,
		required this.priceInRupees,
		required this.createdAt,
		required this.updatedAt,
	});

	factory Gift.fromJson(Map<String, dynamic> json) => Gift(
				giftId: json['gift_id'] as int,
				productName: json['product_name'] as String,
				description: json['description'] as String?,
				quantityInStock: json['quantity_in_stock'] as int,
				priceInRupees: (json['price_in_rupees'] as num).toDouble(),
				createdAt: DateTime.parse(json['created_at']),
				updatedAt: DateTime.parse(json['updated_at']),
			);

	Map<String, dynamic> toJson() => {
				'gift_id': giftId,
				'product_name': productName,
				'description': description,
				'quantity_in_stock': quantityInStock,
				'price_in_rupees': priceInRupees,
				'created_at': createdAt.toIso8601String(),
				'updated_at': updatedAt.toIso8601String(),
			};
}

class GiftApplication {
	final int requestId;
	final String asmId;
	final String doctorId;
	final int giftId;
	final String? occassion;
	final String? message;
	final DateTime? giftDate;
	final String? remarks;
	final String status;
	final DateTime createdAt;
	final DateTime updatedAt;
	// Extra fields for display
	final String? asmName;
	final String? doctorName;
	final String? asmPhoneNo;
	final String? doctorPhoneNo;
	final String? giftName;

	GiftApplication({
		required this.requestId,
		required this.asmId,
		required this.doctorId,
		required this.giftId,
		this.occassion,
		this.message,
		this.giftDate,
		this.remarks,
		required this.status,
		required this.createdAt,
		required this.updatedAt,
		this.asmName,
		this.doctorName,
		this.asmPhoneNo,
		this.doctorPhoneNo,
		this.giftName,
	});

	factory GiftApplication.fromJson(Map<String, dynamic> json) => GiftApplication(
				requestId: json['request_id'] as int,
				asmId: json['asm_id'] as String,
				doctorId: json['doctor_id'] as String,
				giftId: json['gift_id'] as int,
				occassion: json['occassion'] as String?,
				message: json['message'] as String?,
				giftDate: json['gift_date'] != null ? DateTime.tryParse(json['gift_date']) : null,
				remarks: json['remarks'] as String?,
				status: json['status'] as String,
				createdAt: DateTime.parse(json['created_at']),
				updatedAt: DateTime.parse(json['updated_at']),
				asmName: json['asm_name'] as String?,
				doctorName: json['doctor_name'] as String?,
				asmPhoneNo: json['asm_phone_no'] as String?,
				doctorPhoneNo: json['doctor_phone_no'] as String?,
				giftName: json['gift_name'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'request_id': requestId,
				'asm_id': asmId,
				'doctor_id': doctorId,
				'gift_id': giftId,
				'occassion': occassion,
				'message': message,
				'gift_date': giftDate?.toIso8601String(),
				'remarks': remarks,
				'status': status,
				'created_at': createdAt.toIso8601String(),
				'updated_at': updatedAt.toIso8601String(),
				'asm_name': asmName,
				'doctor_name': doctorName,
				'asm_phone_no': asmPhoneNo,
				'doctor_phone_no': doctorPhoneNo,
				'gift_name': giftName,
			};
}
