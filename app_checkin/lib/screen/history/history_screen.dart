import 'package:app_checkin/components/common_refresh_wrapper.dart';
import 'package:app_checkin/models/hotel_model.dart';
import 'package:app_checkin/models/medical_model.dart';
import 'package:app_checkin/provider/hotel_provider.dart';
import 'package:app_checkin/provider/medical_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Lịch sử Check-in',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Tổng hợp các lần check-in của bạn.",
              style: TextStyle(fontSize: 14, color: Color(0xFF7D7D7D)),
            ),
          ],
        ),
      ),
      body: Consumer2<HotelProvider, MedicalProvider>(
        builder: (context, hotelProvider, medicalProvider, child) {
          // Loading state
          final isLoading =
              hotelProvider.isLoadingHotel || medicalProvider.isLoading;

          // Error state
          if (hotelProvider.errisLoadingHotel != null) {
            return Center(child: Text(hotelProvider.errisLoadingHotel!));
          }
          if (medicalProvider.errorMessage != null) {
            return Center(child: Text(medicalProvider.errorMessage!));
          }

          // Combine data
          final combinedList = [
            if (hotelProvider.currentBooking != null)
              hotelProvider.currentBooking!,
            ...medicalProvider.appointments,
          ];

          return CommonRefreshWrapper(
            onRefresh: () async {
              await Future.wait([
                hotelProvider.fetchBookings(),
                medicalProvider.getUserAppointments(),
              ]);
            },
            padding: const EdgeInsets.all(15),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : combinedList.isEmpty
                ? const Center(child: Text("Chưa có lịch sử nào."))
                : Column(
                    children: combinedList.map((item) {
                      if (item is HotelBookingModel) {
                        return _itemHistory(
                          id: item.bookingId,
                          title: item.hotelName,
                          subtitle:
                              "${item.roomInfo.roomType} - ${item.roomInfo.roomNumber}",
                          time:
                              "${item.checkInDate.toLocal().toString().split(' ')[0]} - ${item.checkOutDate.toLocal().toString().split(' ')[0]}",
                          address: item.hotelName,
                          icon: Icons.hotel,
                          color: Colors.blue,
                        );
                      } else if (item is MedicalAppointmentModel) {
                        return _itemHistory(
                          id: item.appointmentId,
                          title: "${item.hospitalName} - ${item.department}",
                          subtitle:
                              "${item.doctorInfo.doctorName} - ${item.appointmentType}",
                          time: item.appointmentTime,
                          address: item.hospitalName,
                          icon: Icons.local_hospital,
                          color: Colors.red,
                        );
                      }
                      return const SizedBox.shrink();
                    }).toList(),
                  ),
          );
        },
      ),
    );
  }

  Widget _itemHistory({
    required String id,
    required String title,
    required String subtitle,
    required String time,
    required String address,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                // Subtitle
                Text(subtitle, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),

                // Address
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        address,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Time
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
