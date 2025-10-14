import 'package:dio/dio.dart';

class BaseHttp {
  final Dio _dio;

  BaseHttp({
    String baseUrl = "https://unganged-monorhinous-theron.ngrok-free.dev",
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 20),
           receiveTimeout: const Duration(seconds: 20),
           headers: {'Content-Type': 'application/json'},
         ),
       );

  Dio get client => _dio;

  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  String handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Kết nối thất bại, vui lòng thử lại.";
      case DioExceptionType.receiveTimeout:
        return "Server không phản hồi, vui lòng thử lại.";
      case DioExceptionType.badResponse:
        return error.response?.data.toString() ?? "Lỗi server";
      case DioExceptionType.cancel:
        return "Request bị hủy";
      case DioExceptionType.unknown:
      default:
        return "Lỗi không xác định: ${error.message}";
    }
  }

  /// Hàm request trả về cả statusCode và dữ liệu
  Future<Map<String, dynamic>> request({
    required String path,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method, headers: headers),
      );

      return {'statusCode': response.statusCode, 'data': response.data};
    } on DioException catch (e) {
      // Trả về lỗi kèm status code nếu có
      return {
        'statusCode': e.response?.statusCode ?? 500,
        'error': handleError(e),
      };
    }
  }
}
