import 'package:app_checkin/contants/router_path.dart';
import 'package:app_checkin/models/user_model.dart';
import 'package:app_checkin/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart' hide Address;

class ScanCccd extends StatelessWidget {
  const ScanCccd({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quét CCCD")),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? rawValue = barcode.rawValue;
            if (rawValue != null) {
              final parts = rawValue.split('|');

              if (parts.length >= 6) {
                final addressParts = Utils.splitAddress(parts[5]);
                final userData = UserModel(
                  id: user.id,
                  userId: user.userId,
                  identification: Identification(
                    idNumber: parts[0],
                    issueDate: _formatDate(parts[6]),
                  ),
                  personalInfo: PersonalInfo(
                    fullName: parts[2],
                    dateOfBirth: _formatDate(parts[3]),
                    gender: parts[4],
                    address: Address(
                      street: addressParts['street'] ?? '',
                      ward: addressParts['ward'] ?? '',
                      district: addressParts['district'] ?? '',
                      city: addressParts['city'] ?? '',
                    ),
                    email: user.personalInfo.email,
                  ),
                  faceData: user.faceData,
                  images: user.images,
                );

                Navigator.pushNamed(
                  context,
                  RoutePaths.editProfile,
                  arguments: userData,
                );
              }
            }
          }
        },
      ),
    );
  }

  String _formatDate(String input) {
    if (input.length == 8) {
      return "${input.substring(0, 2)}/${input.substring(2, 4)}/${input.substring(4)}";
    }
    return input;
  }
}
