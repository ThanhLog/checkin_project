import 'dart:io';
import 'package:app_checkin/contants/router_path.dart';
import 'package:app_checkin/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewRegister extends StatelessWidget {
  final String fullName;
  final String email;
  final String tel;
  final List<File> capturedImages;

  const PreviewRegister({
    super.key,
    required this.fullName,
    required this.email,
    required this.tel,
    required this.capturedImages,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (!authProvider.isLoading &&
              authProvider.errorMessage == null &&
              authProvider.userData != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, RoutePaths.login);
            });
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Xác nhận thông tin'),
              backgroundColor: Colors.green,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin cơ bản',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('Họ tên', fullName),
                  _buildInfoRow('Email', email),
                  _buildInfoRow('Tel', tel),
                  const SizedBox(height: 16),
                  const Text(
                    'Ảnh khuôn mặt',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: capturedImages.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            capturedImages[index],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (authProvider.errorMessage != null)
                    Container(
                      color: Colors.redAccent,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        authProvider.errorMessage!,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: authProvider.isLoading
                            ? null
                            : () {
                                _uploadData(context, authProvider);
                              },
                        child: Text(
                          authProvider.isLoading
                              ? "Đang gửi..."
                              : "Xác nhận & Gửi",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text('$label:')),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _uploadData(BuildContext context, AuthProvider provider) {
    final userId = "user_${DateTime.now().millisecondsSinceEpoch}";
    provider.registerUser(
      userId: userId,
      fullName: fullName,
      email: email,
      tel: tel,
      faceImages: capturedImages,
    );
  }
}
