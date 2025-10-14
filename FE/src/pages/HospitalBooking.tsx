import { useEffect, useState } from "react";
import {
  getMedicalAppointments,
  checkInMedicalWithFace,
  // checkOutMedicalWithFace,
} from "../api/hospitalBookingApi";
import CameraView from "../components/CameraView";
import type { MedicalAppointmentModel } from "../models/MedicalAppointmentModel";

const HospitalBooking = () => {
  const [appointments, setAppointments] = useState<MedicalAppointmentModel[]>(
    []
  );
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const [capturedFile, setCapturedFile] = useState<File | null>(null);
  const [processingId, setProcessingId] = useState<string | null>(null);

  // 📦 Lấy danh sách lịch hẹn
  useEffect(() => {
    const fetchAppointments = async () => {
      try {
        const data = await getMedicalAppointments(0, 20);
        if (Array.isArray(data)) {
          setAppointments(data);
        } else {
          console.warn("⚠️ Dữ liệu không phải mảng:", data);
          setAppointments([]);
        }
      } catch (err) {
        console.error("❌ Fetch failed:", err);
        setAppointments([]);
      } finally {
        setLoading(false);
      }
    };
    fetchAppointments();
  }, []);

  // 🔍 Lọc theo tên bệnh viện
  const filteredAppointments = appointments.filter((a) =>
    a.hospital_name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  // 📸 Check-in bằng khuôn mặt
  const handleFaceCheckIn = async (appointmentId: string) => {
    if (!capturedFile) {
      alert("⚠️ Vui lòng chụp khuôn mặt trước!");
      return;
    }

    setProcessingId(appointmentId);
    try {
      const res = await checkInMedicalWithFace(appointmentId, capturedFile);
      alert(`✅ Check-in thành công!\nMã lịch hẹn: ${appointmentId}`);
    } catch (err: any) {
      alert(
        `❌ Check-in thất bại!\nLý do: ${
          err.response?.data?.detail || err.message
        }`
      );
    } finally {
      setProcessingId(null);
    }
  };

  // 📸 Check-out bằng khuôn mặt
  // const handleFaceCheckOut = async (appointmentId: string) => {
  //   if (!capturedFile) {
  //     alert("⚠️ Vui lòng chụp khuôn mặt trước!");
  //     return;
  //   }

  //   setProcessingId(appointmentId);
  //   try {
  //     const res = await checkOutMedicalWithFace(appointmentId, capturedFile);
  //     alert(`✅ Check-out thành công!\nMã lịch hẹn: ${appointmentId}`);
  //   } catch (err: any) {
  //     alert(
  //       `❌ Check-out thất bại!\nLý do: ${
  //         err.response?.data?.detail || err.message
  //       }`
  //     );
  //   } finally {
  //     setProcessingId(null);
  //   }
  // };

  if (loading) return <p>⏳ Đang tải danh sách lịch hẹn...</p>;

  return (
    <div className="flex p-4 gap-4">
      <div className="flex-1">
        <h1 className="text-xl font-bold mb-4">📋 Danh sách lịch khám</h1>

        <input
          type="text"
          placeholder="Tìm theo tên bệnh viện..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="border border-gray-300 rounded-lg px-3 py-2 w-full mb-4 focus:outline-none focus:ring-2 focus:ring-indigo-400"
        />

        {filteredAppointments.length === 0 ? (
          <p>Không có lịch hẹn nào phù hợp</p>
        ) : (
          <div className="space-y-3">
            {[...filteredAppointments]
              .sort(
                (a, b) =>
                  new Date(b.created_at).getTime() -
                  new Date(a.created_at).getTime()
              )
              .map((a) => (
                <div
                  key={a._id}
                  className="p-4 bg-white shadow rounded-xl border border-gray-200"
                >
                  <h2 className="font-semibold text-indigo-700">
                    {a.hospital_name}
                  </h2>
                  <p>
                    <strong>Mã lịch hẹn:</strong> {a.appointment_id}
                  </p>
                  <p>
                    <strong>Bác sĩ:</strong> {a.doctor_info.doctor_name} (
                    {a.doctor_info.specialization})
                  </p>
                  <p>
                    <strong>Thời gian:</strong> {a.appointment_date}{" "}
                    {a.appointment_time}
                  </p>
                  <p>
                    <strong>Trạng thái:</strong> {a.status}
                  </p>

                  <button
                    onClick={() => handleFaceCheckIn(a.appointment_id)}
                    disabled={processingId === a.appointment_id}
                    className={`mt-3 px-4 py-2 rounded-lg text-white ${
                      processingId === a.appointment_id
                        ? "bg-gray-400"
                        : "bg-indigo-600 hover:bg-indigo-700"
                    }`}
                  >
                    {processingId === a.appointment_id
                      ? "⏳ Đang check-in..."
                      : "📸 Check-in bằng khuôn mặt"}
                  </button>

                  {/* <button
                    onClick={() => handleFaceCheckOut(a.appointment_id)}
                    disabled={processingId === a.appointment_id}
                    className={`mt-3 ml-3 px-4 py-2 rounded-lg text-white ${
                      processingId === a.appointment_id
                        ? "bg-gray-400"
                        : "bg-indigo-600 hover:bg-indigo-700"
                    }`}
                  >
                    {processingId === a.appointment_id
                      ? "⏳ Đang check-out..."
                      : "📸 Check-out bằng khuôn mặt"}
                  </button> */}
                </div>
              ))}
          </div>
        )}
      </div>

      <div className="w-[400px] flex flex-col items-center">
        <CameraView onCapture={(file) => setCapturedFile(file)} />
      </div>
    </div>
  );
};

export default HospitalBooking;
