import React, { useRef, useState, useEffect } from "react";
import { UserInfo } from "../pages/user/UserInfo";
import type { UserModel } from "../models/UserModel";

interface Props {
  onCapture: (file: File) => void;
}

const CameraView: React.FC<Props> = ({ onCapture }) => {
  const videoRef = useRef<HTMLVideoElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [previewUrl, setPreviewUrl] = useState<string | null>(null);
  const [stream, setStream] = useState<MediaStream | null>(null);
  const [userInfo, setUserInfo] = useState<UserModel | null>(null);
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  // 🎥 Mở camera khi component mount
  useEffect(() => {
    startCamera();
    return () => stopCamera();
  }, []);

  const startCamera = async () => {
    try {
      const s = await navigator.mediaDevices.getUserMedia({ video: true });
      setStream(s);
      if (videoRef.current) videoRef.current.srcObject = s;
    } catch (err) {
      console.error("❌ Không thể mở camera:", err);
      alert("Không thể truy cập camera. Vui lòng kiểm tra quyền truy cập.");
    }
  };

  const stopCamera = () => {
    if (stream) {
      stream.getTracks().forEach((track) => track.stop());
      setStream(null);
    }
  };

  // 📸 Hàm chụp ảnh
  const handleCapture = async () => {
    const canvas = canvasRef.current;
    const video = videoRef.current;
    if (!canvas || !video) return;

    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
    canvas.toBlob(async (blob) => {
      if (!blob) return;

      const file = new File([blob], "face.png", { type: "image/png" });

      // 🧩 Gửi file này lên component cha (để lưu lại dùng cho check-in/out)
      onCapture(file);

      // Hiển thị preview ảnh
      setPreviewUrl(URL.createObjectURL(blob));

      // ❗ Không dừng camera ở đây nữa nếu muốn giữ ảnh — chỉ dừng khi thành công
      // stopCamera();

      try {
        setLoading(true);
        setErrorMessage(null);
        setUserInfo(null);

        const formData = new FormData();
        formData.append("face_image", file);

        const res = await fetch("http://localhost:8000/auth/face-check", {
          method: "POST",
          body: formData,
        });

        if (!res.ok) throw new Error("Face check failed");

        const data = await res.json();

        // ✅ Nếu nhận dạng thành công
        if (data?.personal_info) {
          setUserInfo(data);
        } else {
          throw new Error("Không có thông tin người dùng!");
        }
      } catch (err) {
        console.error(err);
        setErrorMessage("Không thể nhận diện khuôn mặt hoặc lấy thông tin!");
      } finally {
        setLoading(false);
      }
    });
  };


  // 🔁 Chụp lại
  const handleRetake = async () => {
    setPreviewUrl(null);
    await startCamera(); // ✅ Mở lại camera mới
  };

  return (
    <div className="flex flex-col items-center">
      {!previewUrl ? (
        <>
          {/* Live Camera */}
          <video
            ref={videoRef}
            autoPlay
            playsInline
            className="w-full rounded-lg shadow-md"
          />
          <canvas ref={canvasRef} width={320} height={240} hidden />
          <button
            onClick={handleCapture}
            className="mt-3 bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-xl"
          >
            📸 Chụp khuôn mặt
          </button>
        </>
      ) : (
        <>
          {/* Ảnh Preview */}
          <img
            src={previewUrl}
            alt="Preview"
            className="w-full rounded-lg shadow-md object-cover"
          />
          <button
            onClick={handleRetake}
            className="mt-3 bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded-xl"
          >
            🔁 Chụp lại
          </button>
        </>
      )}

      <div className="mt-6">
        {errorMessage ? (
          <div className="p-4 bg-red-100 text-red-700 rounded-lg shadow">
            {errorMessage}
          </div>
        ) : userInfo ? (
          <UserInfo user={userInfo} />
        ) : null}
      </div>
    </div>
  );
};

export default CameraView;
