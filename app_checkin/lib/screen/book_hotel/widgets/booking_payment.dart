import 'package:flutter/material.dart';

class BookingPayment extends StatelessWidget {
  final String hotelName;
  final String roomType;
  final String checkInDate;
  final String checkOutDate;
  final int numberGuest;
  final String totalPrice;

  const BookingPayment({
    super.key,
    required this.hotelName,
    required this.roomType,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberGuest,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Thanh toán",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        _infoRow("Khách sạn", hotelName),
        _infoRow("Loại phòng", roomType),
        _infoRow("Ngày nhận phòng", checkInDate),
        _infoRow("Ngày trả phòng", checkOutDate),
        _infoRow("Số lượng khách", numberGuest.toString()),
        const Divider(height: 30, thickness: 1),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Tổng tiền:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              totalPrice,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        const Text(
          "Chọn phương thức thanh toán",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        _paymentOption("Thanh toán thẻ tín dụng/debit", Icons.credit_card),
        _paymentOption("Ví điện tử", Icons.account_balance_wallet),
        _paymentOption("QR Code", Icons.qr_code),

        const SizedBox(height: 30),

        Center(
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Thanh toán thành công ✅")),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Thanh toán", style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text("$label:")),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _paymentOption(String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
