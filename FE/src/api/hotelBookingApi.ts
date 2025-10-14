import axios from "axios";
import type { HotelBookingModel } from "../models/HotelBookingModel";

// Cấu hình base URL
const BASE_URL = "http://localhost:8000";

const api = axios.create({
  baseURL: BASE_URL,
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json",
  },
});

// =============================
// 🏨 GET all hotel bookings
// =============================
export const getHotelBookings = async (
  _skip = 0,
  _limit = 100
): Promise<HotelBookingModel[]> => {
  try {
    const res = await api.get(`/hotel/bookings/?skip=0&limit=100`);
    console.log("✅ API response:", res.data);
    return res.data as HotelBookingModel[];
  } catch (error: any) {
    console.error("❌ Error fetching hotel bookings:", error.message);
    if (error.response) {
      console.error("🔍 Response data:", error.response.data);
    }
    return [];
  }
};

// =============================
// 📸 POST check-in bằng khuôn mặt
// =============================
export const checkInWithFace = async (
  bookingId: string,
  file: File
): Promise<any> => {
  try {
    const formData = new FormData();
    formData.append("face_image", file);

    const res = await api.post(`/hotel/check-in/${bookingId}`, formData, {
      headers: { "Content-Type": "multipart/form-data" },
    });

    console.log("✅ Check-in success:", res.data);
    return res.data;
  } catch (error: any) {
    // 🧠 Xử lý lỗi chi tiết từ backend
    console.error("❌ Error check-in:", error);

    const message =
      error?.response?.data?.detail ||
      error?.response?.data?.message ||
      "Không thể check-in. Đã xảy ra lỗi.";

    // ném lại lỗi có detail để UI bắt được
    throw new Error(message);
  }
};


// =============================
// 📸 POST check-in bằng khuôn mặt
// =============================
export const checkOutWithFace = async (
  bookingId: string,
  file: File
): Promise<any> => {
  try {
    const formData = new FormData();
    formData.append("face_image", file);

    const res = await api.post(`/hotel/check-out/${bookingId}`, formData, {
      headers: { "Content-Type": "multipart/form-data" },
    });

    console.log("✅ Check-in success:", res.data);
    return res.data;
  } catch (error: any) {
    // 🧠 Xử lý lỗi chi tiết từ backend
    console.error("❌ Error check-in:", error);

    const message =
      error?.response?.data?.detail ||
      error?.response?.data?.message ||
      "Không thể check-in. Đã xảy ra lỗi.";

    // ném lại lỗi có detail để UI bắt được
    throw new Error(message);
  }
};
