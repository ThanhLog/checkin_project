import 'dart:convert';

import 'package:app_checkin/components/progress/progress.dart';
import 'package:app_checkin/contants/router_path.dart';
import 'package:app_checkin/models/medical_model.dart';
import 'package:app_checkin/provider/medical_provider.dart';
import 'package:app_checkin/screen/hospital/widgets/patient_info.dart';
import 'package:app_checkin/screen/hospital/widgets/payment_screen.dart';
import 'package:app_checkin/screen/hospital/widgets/review_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class HospitalScreen extends StatefulWidget {
  const HospitalScreen({super.key});

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  final storage = FlutterSecureStorage();
  int currentStep = 0;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController cccdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateBirthController = TextEditingController();
  // final TextEditingController addressController = TextEditingController();


  final TextEditingController departmentController = TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController doctorIdController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController doctorDeptController = TextEditingController();
  final TextEditingController doctorPhoneController = TextEditingController();
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController appointmentDateController =
      TextEditingController();
  final TextEditingController appointmentTimeController =
      TextEditingController();
  final TextEditingController appointmentTypeController =
      TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController paymentStatusController = TextEditingController();
  final TextEditingController totalCostController = TextEditingController();
  final TextEditingController isEmergencyController = TextEditingController();

  void nextStep() {
    if (currentStep == 0) {
      // Validate step 1
      if (formKey.currentState != null && !formKey.currentState!.validate()) {
        return;
      }
    }

    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Khám chữa bệnh")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Progress(
              progressList: [
                {
                  "step": "1",
                  "title": "Đăng ký thông tin",
                  "done": currentStep >= 0,
                },
                {"step": "2", "title": "Xác nhận", "done": currentStep >= 1},
                {"step": "3", "title": "Thanh toán", "done": currentStep >= 2},
              ],
            ),

            SizedBox(height: 30),

            if (currentStep == 0)
              PatientInfo(
                formKey: formKey,
                cccdController: cccdController,
                nameController: nameController,
                dateBirthController: dateBirthController,
                // addressController: addressController,
                departmentController: departmentController,
                doctorNameController: doctorNameController,
                doctorIdController: doctorIdController,
                specializationController: specializationController,
                doctorDeptController: doctorDeptController,
                doctorPhoneController: doctorPhoneController,
                hospitalNameController: hospitalNameController,
                appointmentDateController: appointmentDateController,
                appointmentTimeController: appointmentTimeController,
                appointmentTypeController: appointmentTypeController,
                reasonController: reasonController,
                statusController: statusController,
                paymentStatusController: paymentStatusController,
                totalCostController: totalCostController,
                isEmergencyController: isEmergencyController,
              ),
            if (currentStep == 1)
              ReviewRegister(
                appointment: MedicalAppointmentModel(
                  id: Uuid().v4(),
                  appointmentId: Uuid().v4(),
                  userId: cccdController.text,
                  hospitalName: hospitalNameController.text,
                  department: departmentController.text,
                  doctorInfo: DoctorInfo(
                    doctorId: doctorIdController.text,
                    doctorName: doctorNameController.text,
                    specialization: specializationController.text,
                    department: doctorDeptController.text,
                    phone: doctorPhoneController.text,
                  ),
                  appointmentDate:
                      DateTime.tryParse(appointmentDateController.text) ??
                      DateTime.now(),
                  appointmentTime: appointmentTimeController.text,
                  appointmentType: appointmentTypeController.text,
                  reason: reasonController.text,
                  status: statusController.text,
                  actualCheckIn: null,
                  checkInFaceVerified: false,
                  paymentStatus: paymentStatusController.text,
                  totalCost: double.tryParse(totalCostController.text) ?? 0,
                  isEmergency:
                      isEmergencyController.text.toLowerCase() == "true",
                  createdAt: DateTime.now(),
                ),
              ),
            if (currentStep == 2) PaymentScreen(hasInsuranceCard: false),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: currentStep == 0
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (currentStep > 0)
                  ElevatedButton(
                    onPressed: prevStep,
                    child: const Text("Quay lại"),
                  ),
                Consumer<MedicalProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              if (currentStep == 2) {
                                final userJson = await storage.read(
                                  key: 'user',
                                );
                                String userId = 'unknown';
                                if (userJson != null) {
                                  final userData = jsonDecode(userJson);
                                  userId = userData['user_id'] ?? 'unknown';
                                }
                                String appointmentId =
                                    'AP${DateTime.now().millisecondsSinceEpoch}';

                                final appointment = MedicalAppointmentModel(
                                  id: Uuid().v4(),
                                  appointmentId: appointmentId,
                                  userId: userId,
                                  hospitalName: hospitalNameController.text,
                                  department: departmentController.text,
                                  doctorInfo: DoctorInfo(
                                    doctorId: doctorIdController.text,
                                    doctorName: doctorNameController.text,
                                    specialization:
                                        specializationController.text,
                                    department: doctorDeptController.text,
                                    phone: doctorPhoneController.text,
                                  ),
                                  appointmentDate: DateTime.parse(
                                    appointmentDateController.text,
                                  ),
                                  appointmentTime:
                                      appointmentTimeController.text,
                                  appointmentType:
                                      appointmentTypeController.text,
                                  reason: reasonController.text,
                                  status: statusController.text,
                                  actualCheckIn: null,
                                  checkInFaceVerified: false,
                                  paymentStatus: paymentStatusController.text,
                                  totalCost:
                                      double.tryParse(
                                        totalCostController.text,
                                      ) ??
                                      0,
                                  isEmergency:
                                      isEmergencyController.text
                                          .toLowerCase() ==
                                      'true',
                                  createdAt: DateTime.now(),
                                );

                                await provider.createAppointment(appointment);

                                if (provider.errorMessage != null) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(provider.errorMessage!),
                                    ),
                                  );
                                } else {
                                  Navigator.pushNamed(
                                    // ignore: use_build_context_synchronously
                                    context,
                                    RoutePaths.appointmentSuccess,
                                    arguments: appointmentId,
                                  );
                                }
                              } else {
                                nextStep();
                              }
                            },
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(currentStep == 2 ? "Hoàn tất" : "Tiếp tục"),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
