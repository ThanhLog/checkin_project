import 'package:app_checkin/contants/app_icon.dart';
import 'package:app_checkin/contants/router_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Utilities extends StatelessWidget {
  const Utilities({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.all(16.0),
    width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiện ích',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              // Expanded(
              //   child: _utilitiesButton(
              //     label: 'Đăng ký khuôn mặt',
              //     iconPath: AppIcons.face,
              //     bgColor: Color(0xFFFEFCE8),
              //     iconColor: Color(0xFFEAC100),
              //     onPressed: () {
              //       // Handle button press
              //     },
              //   ),
              // ),
              // SizedBox(width: 10),
              Expanded(
                child: _utilitiesButton(
                  label: 'Xem lịch sử',
                  iconPath: AppIcons.history,
                  bgColor: Color(0xFFEFF6FF),
                  iconColor: Color(0xFF3675FF),
                  onPressed: () {
                    // Handle button press
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _utilitiesButton(
                  label: 'Đặt khách sạn',
                  iconPath: AppIcons.hotel,
                  bgColor: Color(0xFFECFEFF),
                  iconColor: Color(0xFF0891B2),
                  onPressed: () {
                    Navigator.pushNamed(context, RoutePaths.bookHotel);
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _utilitiesButton(
                  label: 'Khám chữa bệnh',
                  iconPath: AppIcons.ecgHeart,
                  bgColor: Color(0xFFFEF2F2),
                  iconColor: Color(0xFFFF0000),
                  onPressed: () {
                    Navigator.pushNamed(context, RoutePaths.hospital);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _utilitiesButton({
    required String label,
    required String iconPath,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 40,
              height: 40,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            SizedBox(height: 5),
            Text(label),
          ],
        ),
      ),
    );
  }
}
