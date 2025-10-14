import 'package:app_checkin/components/bottom/custom_bottom_navigation.dart';
import 'package:app_checkin/contants/app_icon.dart';
import 'package:app_checkin/provider/hotel_provider.dart';
import 'package:app_checkin/provider/medical_provider.dart';
import 'package:app_checkin/screen/history/history_screen.dart';
import 'package:app_checkin/screen/home/home_screen.dart';
import 'package:app_checkin/screen/notification/notification_screen.dart';
import 'package:app_checkin/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  PageController controller = PageController(initialPage: 0);
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const HomeScreen(),
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => HotelProvider()),
              ChangeNotifierProvider(create: (_) => MedicalProvider()),
            ],
            child: const HistoryScreen(),
          ),
          const NotificationScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        index: index,
        items: [
          {'icon': AppIcons.home, 'label': 'Trang chủ', 'size': 24.0},
          {'icon': AppIcons.date, 'label': 'Lịch sử', 'size': 24.0},
          {'icon': AppIcons.notification, 'label': 'Thông báo', 'size': 24.0},
          {'icon': AppIcons.userCircle, 'label': 'Người dùng', 'size': 24.0},
        ],
        onClick: (i) {
          setState(() {
            index = i;
            controller.jumpToPage(i);
          });
        },
      ),
    );
  }
}
