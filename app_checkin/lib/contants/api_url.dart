class ApiUrl {
  // Địa chỉ server API — bạn chỉ cần thay đổi domain này khi dùng ngrok hoặc domain riêng
  static final String _apiUrl =
      "https://unganged-monorhinous-theron.ngrok-free.dev";

  // -----------------------------------------------------------------------------------------------
  // Root & Health
  static String root = "$_apiUrl/";
  static String health = "$_apiUrl/health";

  // -----------------------------------------------------------------------------------------------
  // ------------------------------------------- USER ---------------------------------------------
  static String createUser = "$_apiUrl/users/";
  static String getAllUsers = "$_apiUrl/users/";
  static String createUserFromJson = "$_apiUrl/users/json/";
  static String getUserById = "$_apiUrl/users/{user_id}";
  static String updateUser = "$_apiUrl/users/{user_id}";
  static String deleteUser = "$_apiUrl/users/{user_id}";
  static String getUserByMongoId = "$_apiUrl/users/id/{user_mongo_id}";
  static String searchUsersByName = "$_apiUrl/users/search/name/{name}";
  static String getUserStatsSummary = "$_apiUrl/users/stats/summary";

  // Face recognition
  static String faceLogin = "$_apiUrl/auth/face-login";
  static String faceVerify = "$_apiUrl/auth/face-verify/{user_id}";
  static String updateFaceEmbeddings =
      "$_apiUrl/users/{user_id}/face-embeddings";

  // Image
  static String getUserImage = "$_apiUrl/images/{folder}/{image_filename}";

  // -----------------------------------------------------------------------------------------------
  // ------------------------------------------- HOTEL --------------------------------------------
  static String createHotelBooking = "$_apiUrl/hotel/bookings/";
  static String getAllHotelBookings = "$_apiUrl/hotel/bookings/";
  static String hotelCheckIn = "$_apiUrl/hotel/check-in/{booking_id}";
  static String hotelCheckOut = "$_apiUrl/hotel/check-out/{booking_id}";
  static String getUserHotelBookings = "$_apiUrl/hotel/bookings/user";
  static String getHotelBooking = "$_apiUrl/hotel/bookings/{booking_id}";
  static String cancelHotelBooking = "$_apiUrl/hotel/bookings/{booking_id}";

  // -----------------------------------------------------------------------------------------------
  // ------------------------------------------ MEDICAL -------------------------------------------
  static String createMedicalAppointment = "$_apiUrl/medical/appointments/";
  static String getAllMedicalAppointments = "$_apiUrl/medical/appointments/";
  static String medicalCheckIn = "$_apiUrl/medical/check-in/{appointment_id}";
  static String completeMedicalAppointment =
      "$_apiUrl/medical/appointments/{appointment_id}/complete";
  static String getUserMedicalAppointments =
      "$_apiUrl/medical/appointments/user/{user_id}";
  static String getMedicalAppointment =
      "$_apiUrl/medical/appointments/{appointment_id}";
  static String cancelMedicalAppointment =
      "$_apiUrl/medical/appointments/{appointment_id}";
  static String getTodayEmergencyAppointments =
      "$_apiUrl/medical/appointments/today/emergency";

  // -----------------------------------------------------------------------------------------------
  // ------------------------------------------- STATS --------------------------------------------
  static String getDashboardStats = "$_apiUrl/stats/dashboard";
}
