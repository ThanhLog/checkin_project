import 'package:app_checkin/contants/app_icon.dart';
import 'package:app_checkin/screen/home/widgets/checkin_history.dart';
import 'package:app_checkin/screen/home/widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Chào, Thành Long"),
        actions: [
          GestureDetector(
            onTap: () {
              // Handle notification tap
            },
            child: Container(
              padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.only(right: 16.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF3F4F6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                AppIcons.notification,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  Color(0xFF3675FF),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CheckInHistoryWidget(),
            Utilities(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
