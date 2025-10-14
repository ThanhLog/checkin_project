import 'package:app_checkin/components/common_refresh_wrapper.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông báo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Tổng hợp các thông báo của bạn.",
              style: TextStyle(fontSize: 14, color: Color(0xFF7D7D7D)),
            ),
          ],
        ),
      ),
      body: CommonRefreshWrapper(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              _itemNotification(
                title: "Thông báo mới từ hệ thống",
                subtitle: "Bạn có một thông báo mới.",
                time: "10:00 AM",
                address: "Hệ thống",
              ),
              _itemNotification(
                title: "Cập nhật ứng dụng",
                subtitle: "Phiên bản mới đã được phát hành.",
                time: "09:30 AM",
                address: "Cửa hàng ứng dụng",
              ),
              _itemNotification(
                title: "Nhắc nhở cuộc họp",
                subtitle: "Cuộc họp với nhóm vào lúc 2:00 PM.",
                time: "08:00 AM",
                address: "Phòng họp A",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemNotification({
    required String title,
    required String subtitle,
    required String time,
    required String address,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Color(0xFF7D7D7D)),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Color(0xFF7D7D7D)),
                  SizedBox(width: 5),
                  Text(
                    time,
                    style: TextStyle(fontSize: 14, color: Color(0xFF7D7D7D)),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Color(0xFF7D7D7D)),
                  SizedBox(width: 5),
                  Text(
                    address,
                    style: TextStyle(fontSize: 14, color: Color(0xFF7D7D7D)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
