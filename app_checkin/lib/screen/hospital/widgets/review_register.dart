import 'package:app_checkin/models/medical_model.dart';
import 'package:flutter/material.dart';

class ReviewRegister extends StatelessWidget {
  const ReviewRegister({super.key, required this.appointment});

  final MedicalAppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Thông tin bệnh nhân ---
          _buildSectionTitle("Thông tin bệnh nhân"),
          _buildInfoRow(
            "CCCD",
            appointment.userId,
          ), // nếu có cccd riêng, đổi trường
          _buildInfoRow(
            "Họ và tên",
            appointment.userId,
          ), // cần map từ user info
          _buildInfoRow(
            "Ngày sinh",
            _formatDate(appointment.appointmentDate),
          ), // ví dụ
          // _buildInfoRow("Địa chỉ", "Chưa có"), // nếu không lưu trong model

          const SizedBox(height: 20),

          // --- Thông tin bác sĩ ---
          _buildSectionTitle("Thông tin bác sĩ"),
          _buildInfoRow("Mã bác sĩ", appointment.doctorInfo.doctorId),
          _buildInfoRow("Tên bác sĩ", appointment.doctorInfo.doctorName),
          _buildInfoRow("Chuyên khoa", appointment.doctorInfo.specialization),
          _buildInfoRow("Khoa", appointment.doctorInfo.department),
          _buildInfoRow("Số điện thoại", appointment.doctorInfo.phone),

          const SizedBox(height: 20),

          // --- Thông tin hẹn khám ---
          _buildSectionTitle("Thông tin hẹn khám"),
          _buildInfoRow("Bệnh viện", appointment.hospitalName),
          _buildInfoRow("Khoa khám", appointment.department),
          _buildInfoRow("Ngày khám", _formatDate(appointment.appointmentDate)),
          _buildInfoRow("Giờ khám", appointment.appointmentTime),
          _buildInfoRow("Loại hẹn", appointment.appointmentType),
          _buildInfoRow("Lý do khám", appointment.reason),

          const SizedBox(height: 20),

          // --- Trạng thái & thanh toán ---
          _buildSectionTitle("Trạng thái & thanh toán"),
          _buildInfoRow("Trạng thái", appointment.status),
          _buildInfoRow("Thanh toán", appointment.paymentStatus),
          _buildInfoRow("Tổng chi phí", "${appointment.totalCost} VND"),
          _buildInfoRow("Khẩn cấp", appointment.isEmergency ? "Có" : "Không"),
          _buildInfoRow(
            "Check-in xác thực khuôn mặt",
            appointment.checkInFaceVerified ? "Đã xác thực" : "Chưa xác thực",
          ),
          _buildInfoRow(
            "Thời gian check-in thực tế",
            appointment.actualCheckIn != null
                ? _formatDateTime(appointment.actualCheckIn!)
                : "Chưa check-in",
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value.isNotEmpty ? value : "Chưa có")),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
