import axios from "axios";
import type { MedicalAppointmentModel } from "../models/MedicalAppointmentModel";

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
// 🔐 POST medicals login
// =============================
export const medicalsLogin = async (id: string, password: string) => {
  try {
    const formData = new URLSearchParams();
    formData.append("id", id);
    formData.append("password", password);

    const res = await api.post("/medicals/login", formData, {
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    });

    console.log("✅ Login success:", res.data);
    return res.data;
  } catch (error: any) {
    console.error("❌ Login error:", error.message);
    if (error.response) {
      console.error("🔍 Response data:", error.response.data);
    }
    throw error;
  }
};

// =============================
// 🏨 GET hospital bookings by id
// =============================
export const getHospitalBookingsById = async (
  hospitalId: String
): Promise<MedicalAppointmentModel[]> => {
  try {
    const res = await api.get(`/medicals/booking/${hospitalId}`);
    console.log("✅ API response:", res.data);
    return res.data as MedicalAppointmentModel[];
  } catch (error: any) {
    console.error("❌ Error fetching hotel bookings:", error.message);
    if (error.response) {
      console.error("🔍 Response data:", error.response.data);
    }
    return [];
  }
};

// =============================
// 🏨 GET all medicals bookings
// =============================
export const getMedicalAppointments = async (
  _skip = 0,
  _limit = 100
): Promise<MedicalAppointmentModel[]> => {
  try {
    const res = await api.get(`/medical/appointments/?skip=0&limit=100`);
    console.log("✅ API response:", res.data);
    return res.data as MedicalAppointmentModel[];
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
export const checkInMedicalWithFace = async (
  appointmentid: string,
  file: File
): Promise<any> => {
  try {
    const formData = new FormData();
    formData.append("face_image", file);

    const res = await api.post(`/medical/check-in/${appointmentid}`, formData, {
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