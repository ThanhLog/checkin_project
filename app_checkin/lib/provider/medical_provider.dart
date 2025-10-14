import 'dart:convert';

import 'package:app_checkin/base/base_provider.dart';
import 'package:app_checkin/models/medical_model.dart';
import 'package:app_checkin/repositories/medical_repostories.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MedicalProvider extends BaseProvider {
  final MedicalRepositories _repo = MedicalRepositories();
  final storage = FlutterSecureStorage();
  List<MedicalAppointmentModel> _appointments = [];
  List<MedicalAppointmentModel> get appointments => _appointments;

  Future<void> getUserAppointments() async {
    final user = await storage.read(key: 'user');

    if (user != null) {
      final userData = jsonDecode(user);
      final userId = userData['user_id'] ?? "";
      
      await execute(() async {
        final data = await _repo.getUserAppointments(userId);
        _appointments = data;
      });
    }
  }

  Future<void> createAppointment(MedicalAppointmentModel appointment) async {
    await execute(() async {
      final result = await _repo.createAppointment(appointment);
      _appointments.add(result);
    });
  }

  Future<void> cancelAppointment(String appointmentId) async {
    await execute(() async {
      final success = await _repo.cancelAppointment(appointmentId);
      if (success) {
        _appointments.removeWhere((a) => a.appointmentId == appointmentId);
      }
    });
  }
}
