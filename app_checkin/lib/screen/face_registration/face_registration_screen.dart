import 'dart:io';
import 'package:app_checkin/contants/router_path.dart';
import 'package:app_checkin/screen/face_registration/face_overlay_painter.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class FaceRegisterScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final String tel;
  const FaceRegisterScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.tel,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FaceRegisterScreenState createState() => _FaceRegisterScreenState();
}

class _FaceRegisterScreenState extends State<FaceRegisterScreen> {
  CameraController? _cameraController;
  final List<File> _capturedImages = [];
  int _currentStep = 0; // 0: Trái, 1: Chính diện, 2: Phải
  final List<String> _directions = ['Trái', 'Trực diện', 'Phải'];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController!.initialize();
    setState(() {});
  }

  Future<void> _captureManualImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    // Giới hạn tối đa 3 ảnh
    if (_capturedImages.length >= 3) return;

    try {
      final picture = await _cameraController!.takePicture();
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}/face_${_directions[_currentStep]}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(path);
      await picture.saveTo(file.path);

      setState(() {
        _capturedImages.add(file);

        // Chỉ tăng step nếu chưa tới 2
        if (_currentStep < 2) _currentStep++;
      });
    } catch (e) {
      throw ("Lỗi chụp ảnh: $e");
    }
  }

  void _goToPreview() {
    if (_capturedImages.isNotEmpty) {
      Navigator.pushNamed(
        context,
        RoutePaths.previewRegister,
        arguments: {
          'fullName': widget.fullName,
          'email': widget.email,
          'tel': widget.tel,
          'capturedImages': _capturedImages,
        },
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _cameraController!.value.previewSize!.height,
                height: _cameraController!.value.previewSize!.width,
                child: CameraPreview(_cameraController!),
              ),
            ),
          ),
          // Overlay mask khuôn mặt
          CustomPaint(size: Size.infinite, painter: FaceOverlayPainter()),
          _buildOverlayText(),
          _buildBottomPreview(),
          _buildCaptureButton(),
        ],
      ),
    );
  }

  Widget _buildOverlayText() {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      child: Text(
        _currentStep < 3
            ? "Hướng: ${_directions[_currentStep]}"
            : "Đã chụp xong 3 ảnh",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          backgroundColor: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    final isFinished = _capturedImages.length >= 3;

    return Positioned(
      bottom: 120,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: isFinished ? _goToPreview : _captureManualImage,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isFinished
                  ? LinearGradient(
                      colors: [Colors.grey.shade400, Colors.grey.shade600],
                    )
                  : LinearGradient(colors: [Colors.greenAccent, Colors.green]),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                isFinished ? "Hoàn tất" : "Chụp",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPreview() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black54,
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _capturedImages.length,
          itemBuilder: (context, index) {
            final file = _capturedImages[index];
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Nút xoá
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _capturedImages.removeAt(index);
                        if (_currentStep > 0) _currentStep--;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
