import 'dart:convert';

import 'package:app_checkin/data/hotel.dart';
import 'package:app_checkin/models/hotel_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FillInfo extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController nameController;
  final TextEditingController telController;
  final TextEditingController cccdController;
  final TextEditingController dateBirthController;
  final TextEditingController numberController;

  final TextEditingController nameHotelController;
  final TextEditingController addressHotelController;
  final TextEditingController roomTypeController;
  final TextEditingController checkOutDateController;
  final TextEditingController roomNumberController;
  final TextEditingController bedTypeController;
  final TextEditingController floorController;
  final TextEditingController priceController;
  final TextEditingController checkInDateController;

  const FillInfo({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.telController,
    required this.cccdController,
    required this.dateBirthController,
    required this.numberController,
    required this.nameHotelController,
    required this.addressHotelController,
    required this.roomTypeController,
    required this.checkOutDateController,
    required this.roomNumberController,
    required this.bedTypeController,
    required this.floorController,
    required this.priceController,
    required this.checkInDateController,
  });

  @override
  State<FillInfo> createState() => _FillInfoState();
}

class _FillInfoState extends State<FillInfo> {
  final storage = FlutterSecureStorage();
  HotelBookingModel? selectedBooking;

  Future<void> _fillUserInfoFromStorage() async {
    try {
      final userDataJson = await storage.read(key: 'user');
      if (userDataJson == null) return;

      final userData = jsonDecode(userDataJson);
      setState(() {
        widget.nameController.text =
            userData['personal_info']?['full_name'] ?? '';
        widget.telController.text = userData['personal_info']?['tel'] ?? '';
        widget.cccdController.text = userData['identification']?['id_number'] ?? '';
        widget.dateBirthController.text =
            userData['personal_info']?['date_of_birth'] ?? '';
        widget.numberController.text = "1";
      });
    } catch (e) {
      throw ("Lỗi khi đọc user từ SecureStorage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Thông tin khách hàng",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            "Họ tên",
            "Nhập họ tên",
            widget.nameController,
            icon: Icons.person,
            validator: _requiredValidator,
          ),
          _buildInput(
            "Số điện thoại",
            "Nhập số điện thoại",
            widget.telController,
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: _requiredValidator,
          ),
          _buildInput(
            "CCCD",
            "Nhập số CCCD",
            widget.cccdController,
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            validator: _requiredValidator,
          ),
          _buildInput(
            "Ngày sinh",
            "dd/mm/yyyy",
            widget.dateBirthController,
            icon: Icons.calendar_today,
            keyboardType: TextInputType.datetime,
            validator: _requiredValidator,
          ),
          _buildInput(
            "Số lượng khách",
            "Nhập số khách",
            widget.numberController,
            icon: Icons.group,
            keyboardType: TextInputType.number,
            validator: _requiredValidator,
          ),

          const SizedBox(height: 20),
          const Text(
            "Thông tin phòng",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // --- Chọn khách sạn mẫu ---
          DropdownButtonFormField<HotelBookingModel>(
            value: selectedBooking,
            hint: const Text("Chọn khách sạn mẫu"),
            items: mockHotelBookings
                .map(
                  (booking) => DropdownMenuItem(
                    value: booking,
                    child: Text(booking.hotelName),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedBooking = value;

                  // 🔹 Tự động điền dữ liệu
                  widget.nameHotelController.text = value.hotelName;
                  widget.addressHotelController.text =
                      value.roomInfo.roomNumber;
                  widget.roomTypeController.text = value.roomInfo.roomType;
                  widget.roomNumberController.text = value.roomInfo.roomNumber;
                  widget.bedTypeController.text = value.roomInfo.bedType;
                  widget.floorController.text = value.roomInfo.floor.toString();
                  widget.priceController.text = value.roomInfo.pricePerNight
                      .toString();
                  widget.checkInDateController.text =
                      "${value.checkInDate.day}/${value.checkInDate.month}/${value.checkInDate.year}";
                  widget.checkOutDateController.text =
                      "${value.checkOutDate.day}/${value.checkOutDate.month}/${value.checkOutDate.year}";
                });
              }
            },
          ),

          const SizedBox(height: 20),

          // --- Các trường nhập ---
          _buildInput(
            "Tên khách sạn",
            "Nhập tên khách sạn",
            widget.nameHotelController,
            icon: Icons.hotel,
            validator: _requiredValidator,
          ),
          _buildInput(
            "Số phòng",
            "Nhập số phòng",
            widget.roomNumberController,
            icon: Icons.meeting_room,
            validator: _requiredValidator,
          ),
          _buildInput(
            "Loại phòng",
            "Nhập loại phòng",
            widget.roomTypeController,
            icon: Icons.bed,
            validator: _requiredValidator,
          ),
          _buildInput(
            "Loại giường",
            "Nhập loại giường",
            widget.bedTypeController,
            icon: Icons.king_bed,
            validator: _requiredValidator,
          ),
          _buildInput(
            "Tầng",
            "Nhập số tầng",
            widget.floorController,
            icon: Icons.apartment,
            keyboardType: TextInputType.number,
            validator: _requiredValidator,
          ),
          _buildInput(
            "Giá mỗi đêm (VND)",
            "Nhập giá mỗi đêm",
            widget.priceController,
            icon: Icons.attach_money,
            keyboardType: TextInputType.number,
            validator: _requiredValidator,
          ),
          _buildInput(
            "Ngày nhận phòng",
            "dd/mm/yyyy",
            widget.checkInDateController,
            icon: Icons.calendar_today,
            keyboardType: TextInputType.datetime,
            validator: _requiredValidator,
          ),
          _buildInput(
            "Ngày trả phòng",
            "dd/mm/yyyy",
            widget.checkOutDateController,
            icon: Icons.calendar_month,
            keyboardType: TextInputType.datetime,
            validator: _requiredValidator,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInput(
    String label,
    String hint,
    TextEditingController controller, {
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Vui lòng nhập thông tin";
    }
    return null;
  }
}
