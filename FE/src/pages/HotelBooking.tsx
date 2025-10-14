import { useEffect, useState } from "react";
import {
  getHotelBookings,
  checkInWithFace,
  checkOutWithFace,
} from "../api/hotelBookingApi";
import CameraView from "../components/CameraView";
import type { HotelBookingModel } from "../models/HotelBookingModel";

const FaceCheckIn = () => {
  const [bookings, setBookings] = useState<HotelBookingModel[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const [capturedFile, setCapturedFile] = useState<File | null>(null);
  const [processingId, setProcessingId] = useState<string | null>(null);

  useEffect(() => {
    const fetchBookings = async () => {
      try {
        const data = await getHotelBookings(0, 20);
        if (Array.isArray(data)) {
          setBookings(data);
        } else {
          console.warn("⚠️ Dữ liệu không phải mảng:", data);
          setBookings([]);
        }
      } catch (err) {
        console.error("❌ Fetch failed:", err);
        setBookings([]);
      } finally {
        setLoading(false);
      }
    };
    fetchBookings();
  }, []);

  const filteredBookings = bookings.filter((b) =>
    b.hotel_name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const handleFaceCheckIn = async (bookingId: string) => {
    if (!capturedFile) {
      alert("⚠️ Vui lòng chụp khuôn mặt trước!");
      return;
    }

    setProcessingId(bookingId);
    try {
      const res = await checkInWithFace(bookingId, capturedFile);
      alert(`✅ Check-in thành công!\nMã booking: ${bookingId}`);
    } catch (err: any) {
      // 🧩 Hiển thị lỗi chi tiết từ API
      alert(`❌ Check-in thất bại!\nLý do: ${err.message}`);
    } finally {
      setProcessingId(null);
    }
  };

  const handleFaceCheckOut = async (bookingId: string) => {
    if (!capturedFile) {
      alert("⚠️ Vui lòng chụp khuôn mặt trước!");
      return;
    }

    setProcessingId(bookingId);
    try {
      const res = await checkOutWithFace(bookingId, capturedFile);
      alert(`✅ Check-out thành công!\nMã booking: ${bookingId}`);
    } catch (err: any) {
      // 🧩 Hiển thị lỗi chi tiết từ API
      alert(`❌ Check-out thất bại!\nLý do: ${err.message}`);
    } finally {
      setProcessingId(null);
    }
  };

  if (loading) return <p>⏳ Đang tải danh sách booking...</p>;

  return (
    <div className="flex p-4 gap-2">
      <div className="flex-2">
        <h1 className="text-xl font-bold mb-4">📋 Danh sách Booking</h1>
        <div className="flex gap-6">
          <div className="flex-1">
            <input
              type="text"
              placeholder="Tìm khách sạn..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="border border-gray-300 rounded-lg px-3 py-2 w-full mb-4 focus:outline-none focus:ring-2 focus:ring-indigo-400"
            />

            {filteredBookings.length === 0 ? (
  <p>Không có booking nào phù hợp</p>
) : (
  <div className="space-y-3">
    {[...filteredBookings]
      .sort(
        (a, b) =>
          new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
      )
      .map((b) => (
        <div
          key={b._id}
          className="p-4 bg-white shadow rounded-xl border border-gray-200"
        >
          <h2 className="font-semibold text-indigo-700">{b.hotel_name}</h2>
          <p>
            <strong>Mã đặt phòng:</strong> {b.booking_id}
          </p>
          <p>
            <strong>Phòng:</strong> {b.room_info.room_number} (
            {b.room_info.room_type})
          </p>
          <p>
            <strong>Trạng thái:</strong> {b.status}
          </p>

          <button
            onClick={() => handleFaceCheckIn(b.booking_id)}
            disabled={processingId === b.booking_id}
            className={`mt-3 px-4 py-2 rounded-lg text-white ${
              processingId === b.booking_id
                ? "bg-gray-400"
                : "bg-indigo-600 hover:bg-indigo-700"
            }`}
          >
            {processingId === b.booking_id
              ? "⏳ Đang check-in..."
              : "📸 Check-in bằng khuôn mặt"}
          </button>

          <button
            onClick={() => handleFaceCheckOut(b.booking_id)}
            disabled={processingId === b.booking_id}
            className={`mt-3 ml-3 px-4 py-2 rounded-lg text-white ${
              processingId === b.booking_id
                ? "bg-gray-400"
                : "bg-indigo-600 hover:bg-indigo-700"
            }`}
          >
            {processingId === b.booking_id
              ? "⏳ Đang check-out..."
              : "📸 Check-out bằng khuôn mặt"}
          </button>
        </div>
      ))}
  </div>
)}

          </div>
        </div>
      </div>
      <div className="w-[400px] flex flex-col items-center">
        <CameraView onCapture={(file) => setCapturedFile(file)} />
      </div>
    </div>
  );
};

export default FaceCheckIn;
