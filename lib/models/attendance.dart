class Attendance {
  final int? id;
  final String? asmId;
  final DateTime date;
  DateTime? checkIn;
  DateTime? checkOut;
  String? checkInPhotoPath;
  String? checkOutPhotoPath;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Attendance({
    this.id,
    this.asmId,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.checkInPhotoPath,
    this.checkOutPhotoPath,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  bool get isCheckedIn => checkIn != null;
  bool get isCheckedOut => checkOut != null;

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: _readInt(json['id']),
      asmId: _readString(json['asm_id'] ?? json['asmId']),
      date:
          _readDateTime(json['date']) ??
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
      checkIn: _readDateTime(json['check_in_time'] ?? json['checkInTime']),
      checkOut: _readDateTime(json['check_out_time'] ?? json['checkOutTime']),
      checkInPhotoPath: _readString(
        json['check_in_selfie'] ??
            json['checkInSelfie'] ??
            json['check_in_photo'],
      ),
      checkOutPhotoPath: _readString(
        json['check_out_selfie'] ??
            json['checkOutSelfie'] ??
            json['check_out_photo'],
      ),
      status: _readString(json['status']),
      createdAt: _readDateTime(json['created_at'] ?? json['createdAt']),
      updatedAt: _readDateTime(json['updated_at'] ?? json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'asm_id': asmId,
      'date': date.toIso8601String(),
      'check_in_time': checkIn?.toIso8601String(),
      'check_out_time': checkOut?.toIso8601String(),
      'check_in_selfie': checkInPhotoPath,
      'check_out_selfie': checkOutPhotoPath,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Attendance copyWith({
    int? id,
    String? asmId,
    DateTime? date,
    DateTime? checkIn,
    DateTime? checkOut,
    String? checkInPhotoPath,
    String? checkOutPhotoPath,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Attendance(
      id: id ?? this.id,
      asmId: asmId ?? this.asmId,
      date: date ?? this.date,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      checkInPhotoPath: checkInPhotoPath ?? this.checkInPhotoPath,
      checkOutPhotoPath: checkOutPhotoPath ?? this.checkOutPhotoPath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

DateTime? _readDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;

  final asString = value.toString().trim();
  if (asString.isEmpty) return null;

  return DateTime.tryParse(asString);
}

String? _readString(dynamic value) {
  if (value == null) return null;
  final asString = value.toString().trim();
  if (asString.isEmpty) return null;
  return asString;
}

int? _readInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
