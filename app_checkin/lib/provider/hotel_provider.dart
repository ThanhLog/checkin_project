import 'dart:convert';

import 'package:app_checkin/models/hotel_model.dart';
import 'package:app_checkin/repositories/hotel_repostories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HotelProvider extends ChangeNotifier {
  bool _isLoadingHotel = false;
  String? _errorMessageHotel;
  HotelBookingModel? currentBooking;
  final _repository = HotelRepostories();
  final storage = FlutterSecureStorage();

  bool get isLoadingHotel => _isLoadingHotel;
  String? get errisLoadingHotel => _errorMessageHotel;

  void setLoading(bool value) {
    _isLoadingHotel = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessageHotel = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessageHotel = null;
    notifyListeners();
  }

  Future<void> createBooking(HotelBookingModel hotel) async {
    setLoading(true);
    clearError();
    try {
      final result = await _repository.createBooking(hotel);
      currentBooking = result;
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchBookings() async {
    _isLoadingHotel = true;
    _errorMessageHotel = null;
    notifyListeners();

    try {
      final user = await storage.read(key: 'user');

      if (user != null) {
        final userData = jsonDecode(user);
        final userId = userData['user_id'] ?? "";

        final result = await _repository.getBookings(userId);
        currentBooking = result.isNotEmpty ? result.first : null;
      }
    } catch (e) {
      _errorMessageHotel = e.toString();
    } finally {
      _isLoadingHotel = false;
      notifyListeners();
    }
  }

  void clearBooking() {
    currentBooking = null;
    notifyListeners();
  }
}
