import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Khởi tạo instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // --- SAVE ---
  Future<void> saveData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // --- GET ---
  Future<String?> getData(String key) async {
    return await _storage.read(key: key);
  }

  // --- DELETE ---
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  // --- UPDATE (thực ra là overwrite) ---
  Future<void> updateData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // --- CLEAR ALL ---
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // --- SAVE USER MODEL JSON ---
  Future<void> saveUser(Map<String, dynamic> userJson) async {
    // Chuyển Map sang string
    final jsonString = userJson.toString();
    await saveData('user', jsonString);
  }

  // --- GET USER MODEL JSON ---
  Future<Map<String, dynamic>?> getUser() async {
    final jsonString = await getData('user');
    if (jsonString == null) return null;
    return Map<String, dynamic>.from(evalMap(jsonString));
  }

  // --- HELPER: Chuyển string map về Map ---
  Map<String, dynamic> evalMap(String stringMap) {
    // Chú ý: stringMap là dạng "{key: value, ...}"
    // Dùng regex hoặc jsonDecode nếu lưu dạng JSON chuẩn
    final fixed = stringMap.replaceAll("'", '"'); // chuyển ' thành "
    return fixed.isNotEmpty ? Map<String, dynamic>.from(jsonDecode(fixed)) : {};
  }
}
