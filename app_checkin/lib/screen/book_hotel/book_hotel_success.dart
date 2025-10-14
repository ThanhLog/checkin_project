import 'package:app_checkin/contants/app_icon.dart';
import 'package:app_checkin/contants/router_path.dart';
import 'package:app_checkin/models/hotel_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookHotelSuccess extends StatelessWidget {
  final HotelBookingModel hotelBooking;

  const BookHotelSuccess({super.key, required this.hotelBooking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đặt phòng thành công"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppIcons.success,
            // ignore: deprecated_member_use
            color: Colors.green,
            height: 40,
            width: 40,
          ),
          const SizedBox(height: 20),
          const Text(
            "Bạn đã đặt phòng thành công!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "Booking ID: ${hotelBooking.bookingId}",
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "Khách sạn: ${hotelBooking.hotelName}",
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "Loại phòng: ${hotelBooking.roomInfo.roomType}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Quay về home hoặc danh sách booking
              Navigator.pushNamed(context, RoutePaths.splashScreen);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Quay về trang chính"),
          ),
        ],
      ),
    );
  }
}
