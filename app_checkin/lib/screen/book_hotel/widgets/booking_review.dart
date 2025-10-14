import 'package:flutter/material.dart';


class BookingReview extends StatelessWidget {
  final String name;
  final String tel;
  final String cccd;
  final String dateBirth;
  final String numberGuest;

  final String hotelName;
  final String hotelAddress;
  final String roomType;
  final String checkOutDate;
  final String roomNumber;
  final String bedType;
  final String floor;
  final String pricePerNight;
  final String checkInDate;

  const BookingReview({
    super.key,
    required this.name,
    required this.tel,
    required this.cccd,
    required this.dateBirth,
    required this.numberGuest,
    required this.hotelName,
    required this.hotelAddress,
    required this.roomType,
    required this.checkOutDate,
    required this.roomNumber,
    required this.bedType,
    required this.floor,
    required this.pricePerNight,
    required this.checkInDate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Thông tin khách hàng ---
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Xác nhận thông tin khách hàng",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _infoRow("Họ tên", name),
                _infoRow("Số điện thoại", tel),
                _infoRow("CCCD", cccd),
                _infoRow("Ngày sinh", dateBirth),
                _infoRow("Số lượng khách", numberGuest),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- Thông tin phòng ---
          const Text(
            "Xác nhận thông tin phòng",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _infoRow("Tên khách sạn", hotelName),
          _infoRow("Địa chỉ", hotelAddress),
          _infoRow("Loại phòng", roomType),
          _infoRow("Số phòng", roomNumber),
          _infoRow("Loại giường", bedType),
          _infoRow("Tầng", floor),
          _infoRow("Giá mỗi đêm", "$pricePerNight VNĐ"),
          _infoRow("Ngày nhận phòng", checkInDate),
          _infoRow("Ngày trả phòng", checkOutDate),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value.isNotEmpty ? value : "—")),
        ],
      ),
    );
  }
}
