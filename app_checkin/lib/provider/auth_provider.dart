import 'dart:convert';
import 'dart:io';
import 'package:app_checkin/models/user_model.dart';
import 'package:app_checkin/repositories/auth_repostories.dart';
import 'package:app_checkin/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  final SecureStorage _storage = SecureStorage();

  UserModel? userData;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> faceLogin(File faceImage) async {
    setLoading(true);
    clearError();

    try {
      final res = await _repository.faceLogin(faceImage);

      if (res['success'] == true && res['user'] != null) {
        final user = UserModel.fromJson(res['user']);
        userData = user;
        print("User Print Login Provider: ${userData!.toJson()}");

        await _storage.saveData('user', jsonEncode(user.toJson()));
      } else {
        throw Exception(res['message'] ?? "Đăng nhập không thành công");
      }
    } catch (e) {
      print(e.toString());
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> registerUser({
    required String userId,
    required String fullName,
    required String email,
    required String tel,
    required List<File> faceImages,
  }) async {
    setLoading(true);
    clearError();

    try {
      final data = await _repository.registerUser(
        userId: userId,
        fullName: fullName,
        email: email,
        tel: tel,
        faceImages: faceImages,
      );

      userData = data;
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateUser(UserModel newUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedUser = await _repository.updateUser(newUser);
      print("Response User Update: ${updatedUser.toJson()}");
      // Lưu lại vào SecureStorage

      await _storage.updateData('user', jsonEncode(updatedUser.toJson()));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUser() async {
    final jsonString = await _storage.getData('user');
    if (jsonString != null) {
      userData = UserModel.fromJson(jsonDecode(jsonString));
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _storage.deleteData('user');
    userData = null;
    notifyListeners();
  }
}
