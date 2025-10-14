import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final bool hasInsuranceCard;
  const PaymentScreen({super.key, required this.hasInsuranceCard});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Chọn phương thức thanh toán",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // BHYT option
        if (widget.hasInsuranceCard)
          Card(
            child: ListTile(
              leading: const Icon(Icons.health_and_safety, color: Colors.green),
              title: const Text("Thanh toán bằng Thẻ bảo hiểm y tế"),
              subtitle: const Text(
                "Chi phí sẽ được BHYT chi trả theo quy định",
              ),
              trailing: Radio<String>(
                value: "BHYT",
                groupValue: selectedMethod,
                onChanged: (value) {
                  setState(() {
                    selectedMethod = value;
                  });
                },
              ),
            ),
          )
        else
          Card(
            child: ListTile(
              leading: const Icon(Icons.health_and_safety, color: Colors.grey),
              title: const Text("Không có Thẻ BHYT"),
              subtitle: const Text("Vui lòng chọn phương thức thanh toán khác"),
            ),
          ),

        // VNPay
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.account_balance_wallet,
              color: Colors.blue,
            ),
            title: const Text("VNPay"),
            subtitle: const Text("Thanh toán bằng ví điện tử VNPay"),
            trailing: Radio<String>(
              value: "VNPay",
              groupValue: selectedMethod,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
            ),
          ),
        ),

        // Momo
        Card(
          child: ListTile(
            leading: const Icon(Icons.phone_iphone, color: Colors.purple),
            title: const Text("Momo"),
            subtitle: const Text("Thanh toán bằng ví điện tử Momo"),
            trailing: Radio<String>(
              value: "Momo",
              groupValue: selectedMethod,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
            ),
          ),
        ),

        // QR Code
        Card(
          child: ListTile(
            leading: const Icon(Icons.qr_code, color: Colors.black87),
            title: const Text("Quét mã QR"),
            subtitle: const Text("Thanh toán qua QR Code ngân hàng"),
            trailing: Radio<String>(
              value: "QR",
              groupValue: selectedMethod,
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: selectedMethod == null
              ? null
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Bạn đã chọn: $selectedMethod")),
                  );
                },
          child: const Text("Xác nhận thanh toán"),
        ),
      ],
    );
  }
}