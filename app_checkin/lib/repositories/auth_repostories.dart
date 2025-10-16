import 'dart:io';
import 'package:app_checkin/contants/api_url.dart';
import 'package:app_checkin/models/user_model.dart';
import 'package:dio/dio.dart';
import '../base/base_http.dart';

class AuthRepository {
  final BaseHttp _http = BaseHttp();

  Future<Map<String, dynamic>> faceLogin(File faceImage) async {
    try {
      final formData = FormData.fromMap({
        'face_image': await MultipartFile.fromFile(
          faceImage.path,
          filename: 'login_face.png',
        ),
      });

      final response = await _http.request(
        path: ApiUrl.faceLogin,
        method: "POST",
        data: formData,
      );

      final statusCode = response['statusCode'];
      if (statusCode == 200 && response['data'] != null) {
        return response['data'];
      } else {
        throw Exception("Đăng nhập khuôn mặt thất bại: $statusCode");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> registerUser({
    required String userId,
    required String fullName,
    required String email,
    required String tel,
    required List<File> faceImages,
  }) async {
    try {
      final List<MultipartFile> files = [];
      for (int i = 0; i < faceImages.length; i++) {
        files.add(
          await MultipartFile.fromFile(
            faceImages[i].path,
            filename: "face_${i}_$userId.jpg",
          ),
        );
      }

      final formData = FormData.fromMap({
        'user_id': userId,
        'full_name': fullName,
        'email': email,
        'tel': tel,
        'face_image': files.first,
      });

      final response = await _http.request(
        path: ApiUrl.createUser,
        method: "POST",
        data: formData,
      );

      if (response['statusCode'] == 201 && response['data'] != null) {
        return UserModel.fromJson(response['data']);
      } else {
        throw Exception("Đăng ký user thất bại: ${response['statusCode']}");
      }
    } catch (e) {
      throw Exception("Lỗi Đăng Ký User: $e");
    }
  }

  Future<UserModel> updateUser(UserModel user) async {
    try {
      if (user.userId.isEmpty) {
        throw Exception("user_id is required");
      }

      final path = ApiUrl.updateUser.replaceFirst("{user_id}", user.userId);

      final response = await _http.request(
        path: path,
        method: "PUT",
        data: user.toJson(),
      );

      return UserModel.fromJson(response['data']);
    } catch (e) {
      throw Exception("Lỗi khi update user: $e");
    }
  }
}
