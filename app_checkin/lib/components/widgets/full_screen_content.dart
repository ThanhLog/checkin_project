import 'package:app_checkin/contants/router_path.dart';
import 'package:app_checkin/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FullScreenContent extends StatelessWidget {
  const FullScreenContent({super.key});

  Future<void> checkUser(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadUser();
    if (authProvider.userData != null) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, RoutePaths.entrypoint);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, RoutePaths.register);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkUser(context),
      builder: (context, snapshot) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
