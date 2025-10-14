class HotelBookingModel {
  final String id;
  final String bookingId;
  final String userId;
  final String hotelName;
  final RoomInfo roomInfo;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final DateTime? actualCheckIn;
  final DateTime? actualCheckOut;
  final String status;
  final String paymentStatus;
  final double totalAmount;
  final bool checkInFaceVerified;
  final bool checkOutFaceVerified;
  final DateTime createdAt;

  HotelBookingModel({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.hotelName,
    required this.roomInfo,
    required this.checkInDate,
    required this.checkOutDate,
    this.actualCheckIn,
    this.actualCheckOut,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
    required this.checkInFaceVerified,
    required this.checkOutFaceVerified,
    required this.createdAt,
  });

  factory HotelBookingModel.fromJson(Map<String, dynamic> json) {
    return HotelBookingModel(
      id: json['_id'] ?? '',
      bookingId: json['booking_id'] ?? '',
      userId: json['user_id'] ?? '',
      hotelName: json['hotel_name'] ?? '',
      roomInfo: RoomInfo.fromJson(json['room_info'] ?? {}),
      checkInDate:
          DateTime.tryParse(json['check_in_date'] ?? '') ?? DateTime.now(),
      checkOutDate:
          DateTime.tryParse(json['check_out_date'] ?? '') ?? DateTime.now(),
      actualCheckIn: json['actual_check_in'] != null
          ? DateTime.tryParse(json['actual_check_in'])
          : null,
      actualCheckOut: json['actual_check_out'] != null
          ? DateTime.tryParse(json['actual_check_out'])
          : null,
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      checkInFaceVerified: json['check_in_face_verified'] ?? false,
      checkOutFaceVerified: json['check_out_face_verified'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'booking_id': bookingId,
      'user_id': userId,
      'hotel_name': hotelName,
      'room_info': roomInfo.toJson(),
      'check_in_date': checkInDate.toIso8601String(),
      'check_out_date': checkOutDate.toIso8601String(),
      'actual_check_in': actualCheckIn?.toIso8601String(),
      'actual_check_out': actualCheckOut?.toIso8601String(),
      'status': status,
      'payment_status': paymentStatus,
      'total_amount': totalAmount,
      'check_in_face_verified': checkInFaceVerified,
      'check_out_face_verified': checkOutFaceVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class RoomInfo {
  final String roomNumber;
  final String roomType;
  final int floor;
  final String bedType;
  final int maxGuests;
  final double pricePerNight;

  RoomInfo({
    required this.roomNumber,
    required this.roomType,
    required this.floor,
    required this.bedType,
    required this.maxGuests,
    required this.pricePerNight,
  });

  factory RoomInfo.fromJson(Map<String, dynamic> json) {
    return RoomInfo(
      roomNumber: json['room_number'] ?? '',
      roomType: json['room_type'] ?? '',
      floor: json['floor'] ?? 0,
      bedType: json['bed_type'] ?? '',
      maxGuests: json['max_guests'] ?? 0,
      pricePerNight: (json['price_per_night'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_number': roomNumber,
      'room_type': roomType,
      'floor': floor,
      'bed_type': bedType,
      'max_guests': maxGuests,
      'price_per_night': pricePerNight,
    };
  }
}
