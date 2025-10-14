import 'dart:convert';

import 'package:app_checkin/data/medical.dart';
import 'package:app_checkin/models/medical_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PatientInfo extends StatefulWidget {
  const PatientInfo({
    super.key,
    required this.formKey,
    required this.cccdController,
    required this.nameController,
    required this.dateBirthController,
    // required this.addressController,
    required this.doctorNameController,
    required this.doctorIdController,
    required this.specializationController,
    required this.doctorDeptController,
    required this.doctorPhoneController,
    required this.hospitalNameController,
    required this.departmentController,
    required this.appointmentDateController,
    required this.appointmentTimeController,
    required this.appointmentTypeController,
    required this.reasonController,
    required this.statusController,
    required this.paymentStatusController,
    required this.totalCostController,
    required this.isEmergencyController,
  });

  // Form Key
  final GlobalKey<FormState> formKey;

  // Controllers
  final TextEditingController cccdController;
  final TextEditingController nameController;
  final TextEditingController dateBirthController;
  // final TextEditingController addressController;

  final TextEditingController doctorNameController;
  final TextEditingController doctorIdController;
  final TextEditingController specializationController;
  final TextEditingController doctorDeptController;
  final TextEditingController doctorPhoneController;

  final TextEditingController hospitalNameController;
  final TextEditingController departmentController;
  final TextEditingController appointmentDateController;
  final TextEditingController appointmentTimeController;
  final TextEditingController appointmentTypeController;
  final TextEditingController reasonController;

  final TextEditingController statusController;
  final TextEditingController paymentStatusController;
  final TextEditingController totalCostController;
  final TextEditingController isEmergencyController;

  @override
  State<PatientInfo> createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  final storage = FlutterSecureStorage();
  MedicalAppointmentModel? _selectedPreset;

  Future<void> _fillUserInfoFromStorage() async {
    try {
      final userDataJson = await storage.read(key: 'user');
      if (userDataJson == null) return;

      final userData = jsonDecode(userDataJson);
      setState(() {
        widget.nameController.text =
            userData['personal_info']?['full_name'] ?? '';

        widget.cccdController.text = userData['identification']['id_number'] ?? '';
        widget.dateBirthController.text =
            userData['personal_info']?['date_of_birth'] ?? '';
      });
    } catch (e) {
      debugPrint("Lỗi khi đọc user từ SecureStorage: $e");
    }
  }

  void _fillAppointmentPreset(MedicalAppointmentModel data) {
    // -------------------------------------------------  Doctor Info
    widget.doctorIdController.text = data.doctorInfo.doctorId;
    widget.doctorNameController.text = data.doctorInfo.doctorName;
    widget.specializationController.text = data.doctorInfo.specialization;
    widget.doctorPhoneController.text = data.doctorInfo.phone;

    // -------------------------------------------------- Hospital Info
    widget.hospitalNameController.text = data.hospitalName;
    widget.departmentController.text = data.department;
    widget.appointmentDateController.text = data.appointmentDate.toString();
    widget.appointmentTimeController.text = data.appointmentTime.toString();
    widget.appointmentTypeController.text = data.appointmentType;
    widget.reasonController.text = data.reason;
    widget.statusController.text = data.status;
    widget.paymentStatusController.text = data.paymentStatus;
    widget.totalCostController.text = data.totalCost.toString();
    widget.isEmergencyController.text = data.isEmergency.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Thông tin bệnh nhân ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Thông tin bệnh nhân",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ElevatedButton.icon(
                  onPressed: _fillUserInfoFromStorage,
                  icon: const Icon(Icons.person_search, size: 18),
                  label: const Text("Tự động điền"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildInput(
              "Số CCCD",
              "Nhập số CCCD",
              widget.cccdController,
              keyboardType: TextInputType.number,
            ),
            _buildInput("Họ và tên", "Nhập họ và tên", widget.nameController),
            _buildInput("Ngày sinh", "DD/MM/YYYY", widget.dateBirthController),
            // _buildInput("Địa chỉ", "Nhập địa chỉ", widget.addressController),

            const SizedBox(height: 20),

            DropdownButton<MedicalAppointmentModel>(
              value: _selectedPreset,
              hint: const Text("Chọn loại hẹn"),
              items: mockMedicalAppointments.map((key) {
                return DropdownMenuItem(
                  value: key,
                  child: Text(key.hospitalName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPreset = value;
                    _fillAppointmentPreset(value);
                  });
                }
              },
            ),

            SizedBox(height: 20),

            // --- Thông tin bác sĩ ---
            Text(
              "Thông tin bác sĩ",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            _buildInput(
              "Mã bác sĩ",
              "Nhập mã bác sĩ",
              widget.doctorIdController,
            ),
            _buildInput(
              "Tên bác sĩ",
              "Nhập tên bác sĩ",
              widget.doctorNameController,
            ),
            _buildInput(
              "Chuyên khoa",
              "Nhập chuyên khoa",
              widget.specializationController,
            ),
            _buildInput("Khoa", "Nhập khoa", widget.doctorDeptController),
            _buildInput(
              "Số điện thoại",
              "Nhập số điện thoại",
              widget.doctorPhoneController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 20),

            // --- Thông tin hẹn khám ---
            Text(
              "Thông tin hẹn khám",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            // --- Chọn preset ---
            const SizedBox(height: 10),
            _buildInput(
              "Bệnh viện",
              "Nhập tên bệnh viện",
              widget.hospitalNameController,
            ),
            _buildInput(
              "Khoa khám",
              "Nhập khoa khám",
              widget.departmentController,
            ),
            _buildInput(
              "Ngày khám",
              "DD/MM/YYYY",
              widget.appointmentDateController,
            ),
            _buildInput("Giờ khám", "HH:mm", widget.appointmentTimeController),
            _buildInput(
              "Loại hẹn",
              "Nhập loại hẹn",
              widget.appointmentTypeController,
            ),
            _buildInput(
              "Lý do khám",
              "Nhập lý do khám",
              widget.reasonController,
            ),
            _buildInput(
              "Trạng thái",
              "Nhập trạng thái",
              widget.statusController,
            ),
            _buildInput(
              "Thanh toán",
              "Nhập trạng thái thanh toán",
              widget.paymentStatusController,
            ),
            _buildInput(
              "Tổng chi phí",
              "Nhập tổng chi phí",
              widget.totalCostController,
              keyboardType: TextInputType.number,
            ),
            _buildInput(
              "Khẩn cấp?",
              "true/false",
              widget.isEmergencyController,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Vui lòng nhập thông tin";
          }
          return null;
        },
      ),
    );
  }
}
