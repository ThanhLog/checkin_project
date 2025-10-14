import 'package:app_checkin/contants/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckInHistoryWidget extends StatelessWidget {
  const CheckInHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final checkInHistory = [
      '2024-10-01 08:00 AM',
      '2024-10-02 08:05 AM',
      '2024-10-03 07:55 AM',
      '2024-10-04 08:10 AM',
      '2024-10-05 08:00 AM',
    ];
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lịch sử điểm danh',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all( checkInHistory.isEmpty ? 20.0 : 5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: checkInHistory.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppIcons.info,
                        width: 30,
                        height: 30,
                        colorFilter: ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Chưa có lịch sử điểm danh.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: checkInHistory.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text('Điểm danh ngày ${index + 1}'),
                        subtitle: Text('Thời gian: ${checkInHistory[index]}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
