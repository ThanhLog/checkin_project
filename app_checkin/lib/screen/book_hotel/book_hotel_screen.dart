import 'dart:convert';

import 'package:app_checkin/components/progress/progress.dart';
import 'package:app_checkin/contants/router_path.dart';
import 'package:app_checkin/models/hotel_model.dart';
import 'package:app_checkin/provider/hotel_provider.dart';
import 'package:app_checkin/screen/book_hotel/widgets/booking_payment.dart';
import 'package:app_checkin/screen/book_hotel/widgets/booking_review.dart';
import 'package:app_checkin/screen/book_hotel/widgets/fill_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class BookHotelScreen extends StatefulWidget {
  const BookHotelScreen({super.key});

  @override
  State<BookHotelScreen> createState() => _BookHotelScreenState();
}

class _BookHotelScreenState extends State<BookHotelScreen> {
  final storage = FlutterSecureStorage();
  int currentStep = 0;

  // Thông tin user
  final TextEditingController nameController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController cccdController = TextEditingController();
  final TextEditingController dateBirthController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  // Thông tin phòng
  final TextEditingController nameHotelController = TextEditingController();
  final TextEditingController addressHotelController = TextEditingController();
  final TextEditingController roomTypeController = TextEditingController();
  final TextEditingController checkOutDateController = TextEditingController();
  final TextEditingController roomNumberController = TextEditingController();
  final TextEditingController bedTypeController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController checkInDateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void nextStep() {
    if (currentStep == 0) {
      // Validate step 1
      if (formKey.currentState != null && !formKey.currentState!.validate()) {
        // Form không hợp lệ → không chuyển bước
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
      appBar: AppBar(title: const Text("Đặt khách sạn")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Progress(
              progressList: [
                {"step": "1", "title": "Chọn phòng", "done": currentStep >= 0},
                {"step": "2", "title": "Xác nhận", "done": currentStep >= 1},
                {"step": "3", "title": "Thanh toán", "done": currentStep >= 2},
              ],
            ),
            const SizedBox(height: 30),

            if (currentStep == 0)
              FillInfo(
                formKey: formKey,
                nameController: nameController,
                telController: telController,
                cccdController: cccdController,
                dateBirthController: dateBirthController,
                numberController: numberController,
                nameHotelController: nameHotelController,
                addressHotelController: addressHotelController,
                roomTypeController: roomTypeController,
                checkOutDateController: checkOutDateController,
                roomNumberController: roomNumberController,
                bedTypeController: bedTypeController,
                floorController: floorController,
                priceController: priceController,
                checkInDateController: checkInDateController,
              ),
            if (currentStep == 1)
              BookingReview(
                name: nameController.text,
                tel: telController.text,
                cccd: cccdController.text,
                dateBirth: dateBirthController.text,
                numberGuest: numberController.text,

                hotelName: nameHotelController.text,
                hotelAddress: addressHotelController.text,
                roomType: roomTypeController.text,
                checkOutDate: checkOutDateController.text,
                roomNumber: roomNumberController.text,
                bedType: bedTypeController.text,
                floor: floorController.text,
                pricePerNight: priceController.text,
                checkInDate: checkInDateController.text,
              ),

            if (currentStep == 2)
              BookingPayment(
                hotelName: nameHotelController.text,
                roomType: roomTypeController.text,
                checkInDate: checkInDateController.text,
                checkOutDate: checkOutDateController.text,
                numberGuest: int.tryParse(numberController.text) ?? 1,
                totalPrice: priceController.text,
              ),

            const SizedBox(height: 20),

            Consumer<HotelProvider>(
              builder: (_, hotelProvider, __) {
                final isLoading = hotelProvider.isLoadingHotel;
                final error = hotelProvider.errisLoadingHotel;

                return Column(
                  children: [
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
                        ElevatedButton(
                          onPressed: isLoading
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
                                    String bookId =
                                        'BK${DateTime.now().millisecondsSinceEpoch}';
                                    final booking = HotelBookingModel(
                                      id: Uuid().v4(),
                                      bookingId: bookId,
                                      userId: userId,
                                      hotelName: nameHotelController.text,
                                      roomInfo: RoomInfo(
                                        roomNumber: roomNumberController.text,
                                        roomType: roomTypeController.text,
                                        floor:
                                            int.tryParse(
                                              floorController.text,
                                            ) ??
                                            0,
                                        bedType: bedTypeController.text,
                                        maxGuests:
                                            int.tryParse(
                                              numberController.text,
                                            ) ??
                                            1,
                                        pricePerNight:
                                            double.tryParse(
                                              priceController.text,
                                            ) ??
                                            0,
                                      ),
                                      checkInDate: DateFormat(
                                        'dd/MM/yyyy',
                                      ).parse(checkInDateController.text),
                                      checkOutDate: DateFormat(
                                        'dd/MM/yyyy',
                                      ).parse(checkOutDateController.text),
                                      status: 'confirmed',
                                      paymentStatus: 'paid',
                                      totalAmount:
                                          double.tryParse(
                                            priceController.text,
                                          ) ??
                                          0,
                                      checkInFaceVerified: false,
                                      checkOutFaceVerified: false,
                                      createdAt: DateTime.now(),
                                    );

                                    await hotelProvider.createBooking(booking);

                                    if (hotelProvider.errisLoadingHotel !=
                                        null) {
                                      ScaffoldMessenger.of(
                                        // ignore: use_build_context_synchronously
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Lỗi: ${hotelProvider.errisLoadingHotel}",
                                          ),
                                        ),
                                      );
                                    } else if (context.mounted) {
                                      Navigator.pushNamed(
                                        context,
                                        RoutePaths.bookHotelSuccess,
                                        arguments: booking,
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Đặt phòng thành công!",
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    nextStep();
                                  }
                                },
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  currentStep == 2 ? "Hoàn tất" : "Tiếp tục",
                                ),
                        ),
                      ],
                    ),
                    if (error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
