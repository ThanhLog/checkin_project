// import 'package:app_checkin/contants/app_icon.dart';
// import 'package:app_checkin/contants/router_path.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class WarningWidget extends StatelessWidget {
//   const WarningWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(5.0),
//       margin: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.yellow[100],
//         borderRadius: BorderRadius.circular(8.0),
//         border: Border.all(color: Colors.yellow[700]!, width: 1.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Row(
//             children: [
//               SvgPicture.asset(
//                 AppIcons.face,
//                 width: 60,
//                 height: 60,
//                 colorFilter: ColorFilter.mode(
//                   Colors.yellow[900]!,
//                   BlendMode.srcIn,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   title: Text(
//                     'Bạn chưa đăng ký khuôn mặt',
//                     style: TextStyle(
//                       color: Colors.yellow[900],
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: Text(
//                     'Vui lòng đăng ký để sử dụng tính năng nhận diện khuôn mặt.',
//                     style: TextStyle(color: Colors.yellow[900]),
//                   ),
//                   trailing: SizedBox(
//                     width: 30,
//                     height: double.infinity,
//                     child: Align(
//                       alignment: Alignment.topCenter,
//                       child: SvgPicture.asset(
//                         AppIcons.close,
//                         colorFilter: ColorFilter.mode(
//                           Colors.yellow[900]!,
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pushNamed(context, RoutePaths.faceRegistration);
//             },
//             style: TextButton.styleFrom(
//               padding: EdgeInsets.only(right: 10),
//               minimumSize: Size(0, 0),
//               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               splashFactory: NoSplash.splashFactory,
//             ),
//             child: Text(
//               'Đăng ký ngay',
//               style: TextStyle(color: Colors.yellow[900]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
