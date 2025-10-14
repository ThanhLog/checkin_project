import 'package:app_checkin/base/base_http.dart';
import 'package:app_checkin/contants/api_url.dart';
import 'package:app_checkin/models/medical_model.dart';

class MedicalRepositories {
  final BaseHttp _http = BaseHttp();

  /// 🔹 Lấy danh sách cuộc hẹn của user
  Future<List<MedicalAppointmentModel>> getUserAppointments(
    String userId,
  ) async {
    try {
      final response = await _http.request(
        path: ApiUrl.getUserMedicalAppointments.replaceFirst(
          '{user_id}',
          userId,
        ),
        method: "GET",
      );

      final statusCode = response['statusCode'];
      if (statusCode == 200 && response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((e) => MedicalAppointmentModel.fromJson(e)).toList();
      } else {
        throw Exception("Không thể tải danh sách lịch hẹn");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 🔹 Tạo mới một cuộc hẹn
  Future<MedicalAppointmentModel> createAppointment(
    MedicalAppointmentModel appointment,
  ) async {
    try {
      final response = await _http.request(
        path: ApiUrl.createMedicalAppointment,
        method: "POST",
        data: appointment.toJson(),
      );

      final statusCode = response['statusCode'];
      if (statusCode == 201 && response['data'] != null) {
        return MedicalAppointmentModel.fromJson(response['data']);
      } else {
        throw Exception("Không thể tạo lịch hẹn");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 🔹 Hủy lịch hẹn
  Future<bool> cancelAppointment(String appointmentId) async {
    try {
      final response = await _http.request(
        path: ApiUrl.cancelMedicalAppointment.replaceFirst(
          '{appointment_id}',
          appointmentId,
        ),
        method: "DELETE",
      );

      final statusCode = response['statusCode'];
      if (statusCode == 200) {
        return true;
      } else {
        throw Exception("Hủy lịch hẹn thất bại");
      }
    } catch (e) {
      rethrow;
    }
  }
}
