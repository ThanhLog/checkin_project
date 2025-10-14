import 'package:app_checkin/contants/router_path.dart';
import 'package:app_checkin/router/navigator_services.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RoutePaths.splashScreen,
      onGenerateRoute: NavigatorService.generate,
    );
  }
}
