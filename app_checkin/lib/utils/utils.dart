class Utils {
  static Map<String, String> splitAddress(String address) {
    // Tách các phần theo dấu phẩy
    List<String> parts = address.split(',').map((e) => e.trim()).toList();

    String street = '';
    String ward = '';
    String district = '';
    String city = '';

    // Tùy theo độ dài mà gán giá trị phù hợp
    if (parts.length >= 4) {
      street = parts[0];
      ward = parts[1];
      district = parts[2];
      city = parts[3];
    } else if (parts.length == 3) {
      ward = parts[0];
      district = parts[1];
      city = parts[2];
    } else if (parts.length == 2) {
      district = parts[0];
      city = parts[1];
    } else if (parts.length == 1) {
      city = parts[0];
    }

    return {'street': street, 'ward': ward, 'district': district, 'city': city};
  }

  static String convertToIso8601(String dateText) {
    try {
      // Chuyển String dd/MM/yyyy thành DateTime
      final parts = dateText.split('/');
      if (parts.length != 3)
        return dateText; // trả về nguyên bản nếu không hợp lệ

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);
      return date.toIso8601String(); // trả về ISO 8601
    } catch (e) {
      return dateText; // fallback nếu lỗi
    }
  }
}
