import 'dart:io';
import 'package:app_checkin/contants/app_icon.dart';
import 'package:app_checkin/contants/router_path.dart';
import 'package:app_checkin/provider/auth_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      debugPrint("Lỗi khởi tạo camera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _handleFaceLogin() async {
    final authProvider = context.read<AuthProvider>();

    try {
      if (_cameraController == null ||
          !_cameraController!.value.isInitialized) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Camera chưa sẵn sàng")));
        return;
      }

      // Chụp ảnh khuôn mặt
      final XFile image = await _cameraController!.takePicture();
      await authProvider.faceLogin(File(image.path));

      if (authProvider.userData != null) {
        Navigator.pushNamedAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          RoutePaths.entrypoint,
          (route) => false,
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? "Đăng nhập thất bại"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi đăng nhập khuôn mặt: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
        child: Column(
          children: [
            SvgPicture.asset(
              AppIcons.face,
              width: 100,
              height: 100,
              colorFilter: const ColorFilter.mode(
                Color(0xFF1C274C),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Đăng nhập",
              style: TextStyle(
                color: Color(0xFF1C274C),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            const ListTile(
              title: Center(
                child: Text(
                  "Chào mừng bạn quay trở lại!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Center(
                child: Text(
                  "Vui lòng đăng nhập để tiếp tục",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 🔹 CAMERA LOGIN FORM 🔹
            if (!_isCameraInitialized)
              const Center(child: CircularProgressIndicator())
            else
              SizedBox(
                width: 150,
                height: 250,
                child:ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              )),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: authProvider.isLoading
                  ? null
                  : () => _handleFaceLogin(),
              icon: const Icon(Icons.face, color: Colors.white),
              label: authProvider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Đăng nhập bằng khuôn mặt",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C274C),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),

            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: "Bạn chưa có tài khoản? ",
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                children: [
                  TextSpan(
                    text: "Đăng ký",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, RoutePaths.register);
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
