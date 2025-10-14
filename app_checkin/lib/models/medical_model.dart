class MedicalAppointmentModel {
  final String id;
  final String appointmentId;
  final String userId;
  final String hospitalName;
  final String department;
  final DoctorInfo doctorInfo;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String appointmentType;
  final String reason;
  final String status;
  final DateTime? actualCheckIn;
  final bool checkInFaceVerified;
  final String paymentStatus;
  final double totalCost;
  final bool isEmergency;
  final DateTime createdAt;

  MedicalAppointmentModel({
    required this.id,
    required this.appointmentId,
    required this.userId,
    required this.hospitalName,
    required this.department,
    required this.doctorInfo,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentType,
    required this.reason,
    required this.status,
    this.actualCheckIn,
    required this.checkInFaceVerified,
    required this.paymentStatus,
    required this.totalCost,
    required this.isEmergency,
    required this.createdAt,
  });

  factory MedicalAppointmentModel.fromJson(Map<String, dynamic> json) {
    return MedicalAppointmentModel(
      id: json['_id'] ?? '',
      appointmentId: json['appointment_id'] ?? '',
      userId: json['user_id'] ?? '',
      hospitalName: json['hospital_name'] ?? '',
      department: json['department'] ?? '',
      doctorInfo: DoctorInfo.fromJson(json['doctor_info'] ?? {}),
      appointmentDate:
          DateTime.tryParse(json['appointment_date'] ?? '') ?? DateTime.now(),
      appointmentTime: json['appointment_time'] ?? '',
      appointmentType: json['appointment_type'] ?? '',
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
      actualCheckIn: json['actual_check_in'] != null
          ? DateTime.tryParse(json['actual_check_in'])
          : null,
      checkInFaceVerified: json['check_in_face_verified'] ?? false,
      paymentStatus: json['payment_status'] ?? '',
      totalCost: (json['total_cost'] ?? 0).toDouble(),
      isEmergency: json['is_emergency'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'appointment_id': appointmentId,
      'user_id': userId,
      'hospital_name': hospitalName,
      'department': department,
      'doctor_info': doctorInfo.toJson(),
      'appointment_date': appointmentDate.toIso8601String(),
      'appointment_time': appointmentTime,
      'appointment_type': appointmentType,
      'reason': reason,
      'status': status,
      'actual_check_in': actualCheckIn?.toIso8601String(),
      'check_in_face_verified': checkInFaceVerified,
      'payment_status': paymentStatus,
      'total_cost': totalCost,
      'is_emergency': isEmergency,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class DoctorInfo {
  final String doctorId;
  final String doctorName;
  final String specialization;
  final String department;
  final String phone;

  DoctorInfo({
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.department,
    required this.phone,
  });

  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    return DoctorInfo(
      doctorId: json['doctor_id'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      specialization: json['specialization'] ?? '',
      department: json['department'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'specialization': specialization,
      'department': department,
      'phone': phone,
    };
  }
}
