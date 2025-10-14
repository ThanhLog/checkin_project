import 'package:app_checkin/base/base_http.dart';
import 'package:app_checkin/contants/api_url.dart';
import 'package:app_checkin/models/hotel_model.dart';

class HotelRepostories {
  final BaseHttp _http = BaseHttp();

  Future<List<HotelBookingModel>> getBookings(String userId) async {
    try {
      final response = await _http.request(
        path: "${ApiUrl.getUserHotelBookings}/$userId",
        method: "GET",
      );

      if (response['statusCode'] == 200 && response['data'] != null) {
        final list = response['data'] as List;
        return list.map((e) => HotelBookingModel.fromJson(e)).toList();
      } else {
        throw Exception("Không thể lấy danh sách booking");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<HotelBookingModel> createBooking(HotelBookingModel hotel) async {
    try {
      final response = await _http.request(
        path: ApiUrl.createHotelBooking,
        method: "POST",
        data: hotel.toJson(),
      );

      final statusCode = response['statusCode'];
      if (statusCode == 201 && response['data'] != null) {
        return HotelBookingModel.fromJson(response['data']);
      } else {
        throw Exception("code: $statusCode");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      final response = await _http.request(
        path: ApiUrl.cancelHotelBooking.replaceAll("{booking_id}", bookingId),
        method: "DELETE",
      );

      final statusCode = response['statusCode'];
      if (statusCode == 200 || statusCode == 204) {
        return true;
      } else {
        throw Exception("Hủy đặt phòng thất bại (status: $statusCode)");
      }
    } catch (e) {
      throw Exception("Lỗi khi hủy đặt phòng: $e");
    }
  }
}
