import 'package:app_checkin/components/widgets/full_screen_content.dart';
import 'package:app_checkin/contants/router_path.dart';
import 'package:app_checkin/models/hotel_model.dart';
import 'package:app_checkin/models/user_model.dart';
import 'package:app_checkin/my_app/entry_point.dart';
import 'package:app_checkin/provider/hotel_provider.dart';
import 'package:app_checkin/provider/medical_provider.dart';
import 'package:app_checkin/screen/authencation/login_screen.dart';
import 'package:app_checkin/screen/authencation/preview_register.dart';
import 'package:app_checkin/screen/authencation/register_screen.dart';
import 'package:app_checkin/screen/book_hotel/book_hotel_screen.dart';
import 'package:app_checkin/screen/book_hotel/book_hotel_success.dart';
import 'package:app_checkin/screen/face_registration/face_registration_screen.dart';
import 'package:app_checkin/screen/hospital/appointment_success_screen.dart';
import 'package:app_checkin/screen/hospital/hospital_screen.dart';
import 'package:app_checkin/screen/profile/edit_profile.dart';
import 'package:app_checkin/screen/profile/scan_cccd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigatorService {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RoutePaths.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case RoutePaths.faceRegistration:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FaceRegisterScreen(
            fullName: args['fullName'] ?? '',
            email: args['email'] ?? '',
            tel: args['tel'] ?? '',
          ),
        );
      case RoutePaths.previewRegister:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PreviewRegister(
            fullName: args['fullName'] ?? '',
            email: args['email'] ?? '',
            tel: args['tel'] ?? '',
            capturedImages: args['capturedImages'] ?? [],
          ),
        );

      case RoutePaths.scanCccd:
        final args = settings.arguments as UserModel;
        return MaterialPageRoute(builder: (_) => ScanCccd(user: args));
      case RoutePaths.editProfile:
        final args = settings.arguments as UserModel;
        return MaterialPageRoute(builder: (_) => EditProfile(user: args));

      // ============================================== Hotel
      case RoutePaths.bookHotel:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => HotelProvider(),
            child: BookHotelScreen(),
          ),
        );
      case RoutePaths.bookHotelSuccess:
        final args = settings.arguments as HotelBookingModel;
        return MaterialPageRoute(
          builder: (_) => BookHotelSuccess(hotelBooking: args),
        );

      case RoutePaths.hospital:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => MedicalProvider(),
            child: HospitalScreen(),
          ),
        );
      case RoutePaths.appointmentSuccess:
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => AppointmentSuccessScreen(appointmentId: args),
        );

      case RoutePaths.entrypoint:
        return MaterialPageRoute(builder: (_) => const EntryPoint());
      case RoutePaths.splashScreen:
        return MaterialPageRoute(builder: (_) => FullScreenContent());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
